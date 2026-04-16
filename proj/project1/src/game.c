#include "game.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_t* game, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_t* game, unsigned int snum);
static char next_square(game_t* game, unsigned int snum);
static void update_tail(game_t* game, unsigned int snum);
static void update_head(game_t* game, unsigned int snum);

/* Task 1 */
/* map should like this:
####################
#                  #
# d>D    *         #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
#                  #
####################
*/
game_t* create_default_game() {
  game_t* new_game = malloc(sizeof(game_t));
  const size_t num_rows = new_game->num_rows = 18;
  const size_t num_cols = 25;
  new_game->board = malloc(sizeof(char*) * num_rows);
  for (size_t i = 0; i < num_rows; ++i) {
    new_game->board[i] = malloc(sizeof(char) * num_cols);
  }

  const char* row0 = "####################\n";
  const char* row1 = "#                  #\n";

  for (size_t i = 0; i < num_rows; ++i) {
    if (i == 0 || i == num_rows - 1) {
      strncpy(new_game->board[i], row0, num_cols);
    }
    else {
      strncpy(new_game->board[i], row1, num_cols);
    }
  }

  size_t fruit_row = 2, fruit_col = 9;
  new_game->board[fruit_row][fruit_col] = '*';

  new_game->num_snakes = 1;
  new_game->snakes = malloc(sizeof(snake_t) * new_game->num_snakes);
  new_game->snakes[0] = (snake_t){
    .tail_row = 2,
    .tail_col = 2,
    .head_row = 2,
    .head_col = 4,
    .live = true
  };

  new_game->board[2][2] = 'd';
  new_game->board[2][3] = '>';
  new_game->board[2][4] = 'D';

  return new_game;
}

/* Task 2 */
void free_game(game_t* game) {
  for (size_t i = 0; i < game->num_rows; ++i) {
    free(game->board[i]);
  }
  free(game->board);
  free(game->snakes);
  free(game);
  return;
}

/* Task 3 */
void print_board(game_t* game, FILE* fp) {
  for (size_t i = 0; i < game->num_rows; ++i) {
    fprintf(fp, "%s", game->board[i]);
  }
}

/*
  Saves the current game into filename. Does not modify the game object.
  (already implemented for you).
*/
void save_board(game_t* game, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(game, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_t* game, unsigned int row, unsigned int col) { return game->board[row][col]; }

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_t* game, unsigned int row, unsigned int col, char ch) {
  game->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  return c == 'w' || c == 'a' || c == 's' || c == 'd';
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  return c == 'W' || c == 'A' || c == 'S' || c == 'D' || c == 'x';
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  return is_tail(c) || is_head(c) || c == '^' || c == '<' || c == 'v' || c == '>';
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  switch (c) {
  case '^': return 'w';
  case '<': return 'a';
  case 'v': return 's';
  case '>': return 'd';
  default: return '?';
  }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
  switch (c) {
  case 'W': return '^';
  case 'A': return '<';
  case 'S': return 'v';
  case 'D': return '>';
  default: return '?';
  }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  switch (c) {
  case 'v':
  case 's':
  case 'S':
    return cur_row + 1;
  case '^':
  case 'w':
  case 'W':
    return cur_row - 1;
  default:
    return cur_row;
  }
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  switch (c) {
  case '>':
  case 'd':
  case 'D':
    return cur_col + 1;
  case '<':
  case 'a':
  case 'A':
    return cur_col - 1;
  default:
    return cur_col;
  }
}

/*
  Task 4.2

  Helper function for update_game. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_t* game, unsigned int snum) {
  snake_t* snake = &game->snakes[snum];
  char head_char = get_board_at(game, snake->head_row, snake->head_col);
  unsigned int next_row = get_next_row(snake->head_row, head_char);
  unsigned int next_col = get_next_col(snake->head_col, head_char);
  return get_board_at(game, next_row, next_col);
}

/*
  Task 4.3

  Helper function for update_game. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_t* game, unsigned int snum) {
  snake_t* snake = &game->snakes[snum];
  char head_char = get_board_at(game, snake->head_row, snake->head_col);
  unsigned int next_row = get_next_row(snake->head_row, head_char);
  unsigned int next_col = get_next_col(snake->head_col, head_char);
  set_board_at(game, next_row, next_col, head_char);
  set_board_at(game, snake->head_row, snake->head_col, head_to_body(head_char));
  snake->head_row = next_row;
  snake->head_col = next_col;
}

/*
  Task 4.4

  Helper function for update_game. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_t* game, unsigned int snum) {
  snake_t* snake = &game->snakes[snum];
  char tail_char = get_board_at(game, snake->tail_row, snake->tail_col);
  unsigned int next_row = get_next_row(snake->tail_row, tail_char);
  unsigned int next_col = get_next_col(snake->tail_col, tail_char);
  set_board_at(game, snake->tail_row, snake->tail_col, ' ');
  char next_tail = get_board_at(game, next_row, next_col);
  set_board_at(game, next_row, next_col, body_to_tail(next_tail));
  snake->tail_row = next_row;
  snake->tail_col = next_col;
}

/* Task 4.5 */
void update_game(game_t* game, int (*add_food)(game_t* game)) {
  for (unsigned int i = 0; i < game->num_snakes; ++i) {
    if (!game->snakes[i].live) {
      continue;
    }
    char next_cell = next_square(game, i);
    if (next_cell == ' ') {
      update_head(game, i);
      update_tail(game, i);
    }
    else if (next_cell == '*') {
      update_head(game, i);
      add_food(game);
    }
    else { // hit walls or other snakes or itself
      game->snakes[i].live = false;
      set_board_at(game, game->snakes[i].head_row, game->snakes[i].head_col, 'x');
    }
  }
}

/* Task 5.1 */
char* read_line(FILE* fp) {
  char buf[100];
  char* line = NULL;
  size_t len = 0;
  size_t cap = 0;

  while (fgets(buf, sizeof(buf), fp) != NULL) {
    size_t chunk_len = strlen(buf);

    if (len + chunk_len + 1 > cap) {
      size_t new_cap = cap == 0 ? 128 : cap;
      while (len + chunk_len + 1 > new_cap) {
        new_cap *= 2;
      }

      char* tmp = realloc(line, new_cap);
      if (!tmp) {
        free(line);
        return NULL;
      }
      line = tmp;
      cap = new_cap;
    }

    memcpy(line + len, buf, chunk_len + 1);
    len += chunk_len;

    if (len > 0 && line[len - 1] == '\n') {
      return line;
    }
  }

  return len == 0 ? NULL : line;
}

/* Task 5.2 */
game_t* load_board(FILE* fp) { 
  game_t* game = malloc(sizeof(game_t));
  if (game == NULL) {
    return NULL;
  }
  size_t cap = 8;
  game->board = malloc(cap * sizeof(char*));
  if (game->board == NULL) {
    free(game);
    return NULL;
  }
  game->num_rows = 0;
  game->num_snakes = 0;
  game->snakes = NULL;

  char* line;
  while ((line = read_line(fp)) != NULL) {
    if (game->num_rows == cap) {
      cap *= 2;
      char** tmp = realloc(game->board, cap * sizeof(char*));
      if (!tmp) {
        free(line);
        free_game(game);
        return NULL;
      }
      game->board = tmp;
    }
    game->board[game->num_rows ++] = line;
  }

  return game;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_t* game, unsigned int snum) {
  snake_t* snake = &game->snakes[snum];
  unsigned int cur_row = snake->tail_row;
  unsigned int cur_col = snake->tail_col;
  char cur_char = get_board_at(game, cur_row, cur_col);
  while (!is_head(cur_char)) {
    cur_row = get_next_row(cur_row, cur_char);
    cur_col = get_next_col(cur_col, cur_char);
    cur_char = get_board_at(game, cur_row, cur_col);
  }
  snake->head_row = cur_row;
  snake->head_col = cur_col;
}

/* Task 6.2 */
game_t* initialize_snakes(game_t* game) {
  for (unsigned int row = 0; row < game->num_rows; ++row) {
    for (unsigned int col = 0; get_board_at(game, row, col) != '\0' && get_board_at(game, row, col) != '\n'; ++col) {
      char c = get_board_at(game, row, col);
      if (is_tail(c)) {
        snake_t* tmp = realloc(game->snakes, sizeof(snake_t) * (game->num_snakes + 1));
        if (tmp == NULL) {
          free_game(game);
          return NULL;
        }
        game->snakes = tmp;
        snake_t* new_snake = &game->snakes[game->num_snakes];
        new_snake->tail_row = row;
        new_snake->tail_col = col;
        find_head(game, game->num_snakes);
        new_snake->live = true;
        game->num_snakes++;
      }
    }
  }
  return game;
}
