#include <string.h>
#include <stdlib.h>
#include <curses.h>
#include <menu.h>

void print_in_middle(WINDOW *win, int starty, int startx, int width, char *string, chtype color);

int main(int argc, char *argv[])
{
	ITEM **my_items;
	int c;				
	MENU *menu;
        WINDOW *win;
        int i;
if (argc <= 2) return 0;

	/* Initialize curses */
	initscr();
	start_color();
        cbreak();
        noecho();
	keypad(stdscr, TRUE);

	// title
	init_pair(1, COLOR_BLACK, COLOR_WHITE);
	
	// bottom text
	init_pair(2, COLOR_CYAN, COLOR_BLUE);
	
	// background
	init_pair(3, COLOR_BLUE, COLOR_BLUE);

	// window
	init_pair(4, COLOR_RED, COLOR_WHITE);

	// menu
	init_pair(5, COLOR_WHITE, COLOR_BLUE);


	/* Create items */

	int n_choices = argc-2;

        my_items = (ITEM **)calloc(n_choices+1, sizeof(ITEM *));
        for(i = 0; i < n_choices; ++i)
                my_items[i] = new_item(argv[2+i], NULL);

	/* Create menu */
	menu = new_menu((ITEM **)my_items);
	set_menu_fore(menu, COLOR_PAIR(5));
	set_menu_back(menu, COLOR_PAIR(1));

	int width = 76;
	int height = 20;

	bkgd(COLOR_PAIR(3));

	/* Create the window to be associated with the menu */
        win = newwin(height, width, 2, 2);
        keypad(win, TRUE);
	wbkgd(win, COLOR_PAIR(4));

	/* Set main window and sub window */
        set_menu_win(menu, win);
        set_menu_sub(menu, derwin(win, height-3, width-5, 3, 1));
	set_menu_format(menu, height-4, 1);
			
	/* Set menu mark to the string " * " */
        set_menu_mark(menu, " * ");

	/* Print a border around the main window and print a title */
        box(win, 0, 0);
//        wborder(win, '|', '|', '-', '-', '+', '+', '+', '+');     

	print_in_middle(win, 1, 0, width, argv[1], COLOR_PAIR(1));
	mvwaddch(win, 2, 0, ACS_LTEE);
	mvwhline(win, 2, 1, ACS_HLINE, width-1);
	mvwaddch(win, 2, width-1, ACS_RTEE);
        
	/* Post the menu */
	post_menu(menu);
	wrefresh(win);
	
	attron(COLOR_PAIR(2));
	mvprintw(LINES - 2, 0, "Use PageUp and PageDown to scoll down or up a page of items");
	mvprintw(LINES - 1, 0, "Arrow Keys to navigate (ESC to Exit)");
	attroff(COLOR_PAIR(2));
	refresh();
	int itemidx = 0;

	while((c = wgetch(win)) != KEY_F(1))
	{
		if (c == 27) break;
	       switch(c)
	        {
			case KEY_DOWN:
			case 14:
				menu_driver(menu, REQ_DOWN_ITEM);
				break;

			case KEY_UP:
			case 16:
				menu_driver(menu, REQ_UP_ITEM);
				break;
			
			case KEY_NPAGE:
			case 21:
				menu_driver(menu, REQ_SCR_DPAGE);
				break;

			case KEY_PPAGE:
			case 22:
				menu_driver(menu, REQ_SCR_UPAGE);
				break;

			
			case 10:
				itemidx = item_index(current_item(menu))+1;
				goto end;
				break;

		}
                wrefresh(win);
	}	

end:
	/* Unpost and free all the memory taken up */
        unpost_menu(menu);
        free_menu(menu);
        for(i = 0; i < n_choices; ++i)
                free_item(my_items[i]);
	endwin();

	return itemidx;
}

void print_in_middle(WINDOW *win, int starty, int startx, int width, char *string, chtype color)
{	int length, x, y;
	float temp;

	if(win == NULL)
		win = stdscr;
	getyx(win, y, x);
	if(startx != 0)
		x = startx;
	if(starty != 0)
		y = starty;
	if(width == 0)
		width = 80;

	length = strlen(string);
	temp = (width - length)/ 2;
	x = startx + (int)temp;
	wattron(win, color);
	mvwprintw(win, y, x, "%s", string);
	wattroff(win, color);
	refresh();
}


