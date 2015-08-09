/*
 * virtual sound driver, as easy as possible
 *
 * Copyright (C) 2014 Sebastian Macke
 *
 * Based on soc/sh/fsi.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/delay.h>
#include <linux/dma-mapping.h>
#include <linux/pm_runtime.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_device.h>
#include <linux/scatterlist.h>
#include <linux/sh_dma.h>
#include <linux/slab.h>
#include <linux/module.h>
#include <linux/workqueue.h>
#include <sound/soc.h>
#include <sound/pcm_params.h>


static void __virt_snd_reg_write(u32 __iomem *reg, u32 data)
{
        /* valid data area is 24bit */
         __raw_writel(data, reg);
}

static u32 __virt_snd_reg_read(u32 __iomem *reg)
{
        return __raw_readl(reg);
}


struct virt_snd_master {
	u32 __iomem *base;
	struct snd_pcm_substream *substream;
	spinlock_t lock;

};

/* ---------------------------------------------- */

/*
 *              pcm ops
 */

static struct snd_pcm_hardware virt_pcm_hardware = {
        .info =         SNDRV_PCM_INFO_INTERLEAVED      |
                        SNDRV_PCM_INFO_MMAP             |
                        SNDRV_PCM_INFO_MMAP_VALID       |
                        SNDRV_PCM_INFO_PAUSE,
        .buffer_bytes_max       = 128 * 1024,
        .period_bytes_min       = 1*1024,
        .period_bytes_max       = 64*1024,
        .periods_min            = 1,
        .periods_max            = 32,
        .fifo_size              = 128,
};
/*
static void printsubstreaminfo(struct snd_pcm_substream *substream)
{
	printk("virtsound substream info: number=%i name=%s stream_direction=%i  bytes_max=%i timer_running=%i", 
		substream->number,
		substream->name, 
		substream->stream, 
		substream->buffer_bytes_max, 
		substream->timer_running);
}
*/


static int virt_pcm_open(struct snd_pcm_substream *substream)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	int ret = 0;
	//printk("virtsound pcm_ops: pcm_open\n");
	snd_soc_set_runtime_hwparams(substream, &virt_pcm_hardware);

	ret = snd_pcm_hw_constraint_integer(runtime,
        	SNDRV_PCM_HW_PARAM_PERIODS);

	//printsubstreaminfo(substream);

	return ret;
}

static int virt_pcm_hw_params(struct snd_pcm_substream *substream,
                         struct snd_pcm_hw_params *hw_params)
{
	//printk("virtsound pcm_ops: hw_params\n");
        return snd_pcm_lib_malloc_pages(substream,
                                        params_buffer_bytes(hw_params));
}

static int virt_pcm_hw_free(struct snd_pcm_substream *substream)
{
	//printk("virtsound pcm_ops: hw_free\n");
        return snd_pcm_lib_free_pages(substream);
}

/* have to return the current position */
static snd_pcm_uframes_t virt_pcm_pointer(struct snd_pcm_substream *substream)
{
	struct snd_soc_pcm_runtime *rtd;
	struct virt_snd_master *master;
	rtd = substream->private_data;
	master = snd_soc_dai_get_drvdata(rtd->cpu_dai);

//	printk("virtsound pcm_ops: pointer\n");
	return __virt_snd_reg_read(master->base + 0x4);
/*
        return fsi_sample2frame(fsi, io->buff_sample_pos);
*/
}


static struct snd_pcm_ops virt_pcm_ops = {
	.open           = virt_pcm_open,
	.ioctl          = snd_pcm_lib_ioctl,
	.hw_params      = virt_pcm_hw_params,
	.hw_free        = virt_pcm_hw_free,
	.pointer        = virt_pcm_pointer,
};


/* ---------------------------------------------- */

#define PREALLOC_BUFFER         (64 * 1024)
#define PREALLOC_BUFFER_MAX     (64 * 1024)

static void virt_pcm_free(struct snd_pcm *pcm)
{
	//printk("virtsound platform:  pcm_free\n");
        snd_pcm_lib_preallocate_free_for_all(pcm);
}

static int virt_pcm_new(struct snd_soc_pcm_runtime *rtd)
{
        struct snd_pcm *pcm = rtd->pcm;
	//printk("virtsound platform: pcm_new\n");

        /*
         * dont use SNDRV_DMA_TYPE_DEV, since it will oops the SH kernel
         * in MMAP mode (i.e. aplay -M)
         */
        return snd_pcm_lib_preallocate_pages_for_all(
                pcm,
                SNDRV_DMA_TYPE_CONTINUOUS,
                snd_dma_continuous_data(GFP_KERNEL),
                PREALLOC_BUFFER, PREALLOC_BUFFER_MAX);
}



static struct snd_soc_platform_driver virt_soc_platform = {

	.ops            = &virt_pcm_ops,
	.pcm_new        = virt_pcm_new,
	.pcm_free       = virt_pcm_free,

};

/* ---------------------------------------------- */

static int virt_dai_startup(struct snd_pcm_substream *substream,
         struct snd_soc_dai *dai)
{
	//printk("virtsound dai_ops: dai_startup\n");
	return 0;
}

static void virt_dai_shutdown(struct snd_pcm_substream *substream,
        struct snd_soc_dai *dai)
{
	//printk("virtsound dai_ops: dai_shutdown\n");
	return;
}

static int virt_dai_trigger(struct snd_pcm_substream *substream, int cmd,
        struct snd_soc_dai *dai)
{
	struct snd_soc_pcm_runtime *rtd = substream->private_data;
	struct virt_snd_master *master = snd_soc_dai_get_drvdata(rtd->cpu_dai);
	struct snd_pcm_runtime *runtime = substream->runtime;
/*
	printk("virtsound dai_ops: "
		"dai_trigger cmd=%d buffer_size=%d "
		" period_size=%d sample_bits=%d "
		"frame_bits=%d rate=%d channels=%d periods=%d\n", 
		cmd, 
		(int)runtime->buffer_size,
		(int)runtime->period_size,
		(int)runtime->sample_bits,
		(int)runtime->frame_bits,
		(int)runtime->rate,
		(int)runtime->channels,
		(int)runtime->periods
	);
*/
/* get area*/


	switch (cmd)
	{
		case SNDRV_PCM_TRIGGER_START:
			master->substream = substream;
			__virt_snd_reg_write(master->base + 0x1, (u32)virt_to_phys(runtime->dma_area));
			__virt_snd_reg_write(master->base + 0x2, runtime->periods);
			__virt_snd_reg_write(master->base + 0x3, runtime->period_size);
			__virt_snd_reg_write(master->base + 0x5, runtime->rate);
			__virt_snd_reg_write(master->base + 0x6, runtime->channels);
			
			/* start */
			__virt_snd_reg_write(master->base + 0x0, 0x1);

			break;

		case SNDRV_PCM_TRIGGER_STOP:
			__virt_snd_reg_write(master->base + 0x0, 0x0);
			break;
	}
	return 0;
}

static int virt_dai_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
{
	//printk("virtsound dai_ops: dai_set_fmt %x\n", fmt);
	return 0;
}

static int virt_dai_hw_params(struct snd_pcm_substream *substream,
                             struct snd_pcm_hw_params *params,
                             struct snd_soc_dai *dai)
{
	//printk("virtsound dai_ops: dai_hw_params\n");
	return 0;
}


static const struct snd_soc_dai_ops virt_dai_ops = {
        .startup        = virt_dai_startup,
        .shutdown       = virt_dai_shutdown,
        .trigger        = virt_dai_trigger,
        .set_fmt        = virt_dai_set_fmt,
        .hw_params      = virt_dai_hw_params,
};

/* ---------------------------------------------- */


static irqreturn_t virt_interrupt(int irq, void *data)
{
	struct virt_snd_master *master = data;
	// clear interrupt
	__virt_snd_reg_read(master->base + 0x0);

	snd_pcm_period_elapsed(master->substream);

	return IRQ_HANDLED;
}

/* ---------------------------------------------- */


static const struct snd_soc_component_driver virt_soc_component = {
	.name           = "virt",
};

static struct snd_soc_dai_driver virt_soc_dai[] = {
         {
                 .name                   = "virt-dai",
                 .playback = {
                         //.rates        = SNDRV_PCM_RATE_8000_96000,
			 .rates          = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_8000_48000,
			 .rate_min  	 = 5500,
			 .rate_max 	 = 48000,
                         .formats        = SNDRV_PCM_FMTBIT_S16_BE,
                         .channels_min   = 1,
                         .channels_max   = 1,
                 },
		.ops = &virt_dai_ops,
	}
};


static int virt_probe(struct platform_device *pdev)
{
	struct virt_snd_master *master;
	int ret = 0;
	struct resource *res;
	unsigned int irq;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res) {
		dev_err(&pdev->dev, "missing board memory resource\n");
		return -EINVAL;
	}

	irq = platform_get_irq(pdev, 0);
	if (irq < 0) {
		dev_err(&pdev->dev, "missing board IRQ resource\n");
 		return -EINVAL;
	}

	master = devm_kzalloc(&pdev->dev, sizeof(*master), GFP_KERNEL);
	if (!master) {
		dev_err(&pdev->dev, "Could not allocate master\n");
		return -ENOMEM;
	}

	master->base = devm_ioremap_nocache(&pdev->dev,
		res->start, resource_size(res));
	if (!master->base) {
		dev_err(&pdev->dev, "Unable to ioremap virt registers.\n");
		return -ENXIO;
	}

	spin_lock_init(&master->lock);

	dev_set_drvdata(&pdev->dev, master);

	ret = devm_request_irq(&pdev->dev, irq, &virt_interrupt, 0,
			       dev_name(&pdev->dev), master);
	if (ret) {
		dev_err(&pdev->dev, "irq request err\n");
		return ret;
	}

	ret = snd_soc_register_platform(&pdev->dev, &virt_soc_platform);
	if (ret < 0) {
		dev_err(&pdev->dev, "cannot snd soc register\n");
		return ret;
	}


	ret = snd_soc_register_component(&pdev->dev, &virt_soc_component,
				    virt_soc_dai, ARRAY_SIZE(virt_soc_dai));
	if (ret < 0) {
		dev_err(&pdev->dev, "cannot snd component register\n");
		goto exit_snd_soc;
	}

/*
	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
	if (ret) {
		dev_err(&pdev->dev, "Could not register PCM: %d\n", ret);
		return ret;
	}
*/


	return ret;

exit_snd_soc:
	snd_soc_unregister_platform(&pdev->dev);

	return ret;

}

static int virt_remove(struct platform_device *pdev)
{
	struct snd_master *master;

	master = dev_get_drvdata(&pdev->dev);

	snd_soc_unregister_component(&pdev->dev);
	snd_soc_unregister_platform(&pdev->dev);

	return 0;
}

static struct of_device_id virt_of_match[] = {
	{ .compatible = "renesas,sh_fsi2"},
	{},
};
MODULE_DEVICE_TABLE(of, virt_of_match);

static struct platform_driver virt_driver = {
	.driver 	= {
		.name	= "virt-pcm-audio",
		.of_match_table = virt_of_match,
	},
	.probe		= virt_probe,
	.remove		= virt_remove,
};

module_platform_driver(virt_driver);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("audio driver for virtual devices");
MODULE_AUTHOR("Sebastian Macke");
MODULE_ALIAS("platform:virt-pcm-audio");
