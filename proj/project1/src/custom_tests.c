#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "asserts.h"
// Necessary due to static functions in game.c
#include "game.c"

/* Look at asserts.c for some helpful assert functions */

int greater_than_forty_two(int x) { return x > 42; }

bool is_vowel(char c) {
  char *vowels = "aeiouAEIOU";
  for (int i = 0; i < strlen(vowels); i++) {
    if (c == vowels[i]) {
      return true;
    }
  }
  return false;
}

/*
  Example 1: Returns true if all test cases pass. False otherwise.
    The function greater_than_forty_two(int x) will return true if x > 42. False otherwise.
    Note: This test is NOT comprehensive
*/
bool test_greater_than_forty_two() {
  int testcase_1 = 42;
  bool output_1 = greater_than_forty_two(testcase_1);
  if (!assert_false("output_1", output_1)) {
    return false;
  }

  int testcase_2 = -42;
  bool output_2 = greater_than_forty_two(testcase_2);
  if (!assert_false("output_2", output_2)) {
    return false;
  }

  int testcase_3 = 4242;
  bool output_3 = greater_than_forty_two(testcase_3);
  if (!assert_true("output_3", output_3)) {
    return false;
  }

  return true;
}

/*
  Example 2: Returns true if all test cases pass. False otherwise.
    The function is_vowel(char c) will return true if c is a vowel (i.e. c is a,e,i,o,u)
    and returns false otherwise
    Note: This test is NOT comprehensive
*/
bool test_is_vowel() {
  char testcase_1 = 'a';
  bool output_1 = is_vowel(testcase_1);
  if (!assert_true("output_1", output_1)) {
    return false;
  }

  char testcase_2 = 'e';
  bool output_2 = is_vowel(testcase_2);
  if (!assert_true("output_2", output_2)) {
    return false;
  }

  char testcase_3 = 'i';
  bool output_3 = is_vowel(testcase_3);
  if (!assert_true("output_3", output_3)) {
    return false;
  }

  char testcase_4 = 'o';
  bool output_4 = is_vowel(testcase_4);
  if (!assert_true("output_4", output_4)) {
    return false;
  }

  char testcase_5 = 'u';
  bool output_5 = is_vowel(testcase_5);
  if (!assert_true("output_5", output_5)) {
    return false;
  }

  char testcase_6 = 'k';
  bool output_6 = is_vowel(testcase_6);
  if (!assert_false("output_6", output_6)) {
    return false;
  }

  return true;
}

/* Task 4.1 */

bool test_bool_function(bool (*bool_function)(char), const char *test_cases, const bool *expected_outputs) {
  for (int i = 0; i < strlen(test_cases); ++ i) {
    char test_case = test_cases[i];
    bool expected_output = expected_outputs[i];
    bool output = bool_function(test_case);
    if(!assert_equals_bool("output", expected_output, output)) {
      return false;
    }
  }

  return true;
}

bool test_char_function(char (*char_function)(char), const char *test_cases, const char *expected_outputs) {
  for (int i = 0; i < strlen(test_cases); ++ i) {
    char test_case = test_cases[i];
    char expected_output = expected_outputs[i];
    char output = char_function(test_case);
    if(!assert_equals_char("output", expected_output, output)) {
      return false;
    }
  }

  return true;
}

bool test_unsigned_function(unsigned int (*unsigned_function)(unsigned int, char), const char *test_cases, const unsigned int *expected_outputs) {
  for (int i = 0; i < strlen(test_cases); ++ i) {
    char test_case = test_cases[i];
    unsigned int expected_output = expected_outputs[i];
    unsigned int output = unsigned_function(1, test_case);
    if(!assert_equals_unsigned_int("output", expected_output, output)) {
      return false;
    }
  }

  return true;
}

bool test_is_tail() {
  const char *test_cases = "wasdWASDx^<v>k";
  const bool expected_outputs[] = {true, true, true, true, false, false, false, false, false, false, false, false, false, false};
  return test_bool_function(is_tail, test_cases, expected_outputs);
}

bool test_is_head() {
  const char *test_cases = "wasdWASDx^<v>k";
  const bool expected_outputs[] = {false, false, false, false, true, true, true, true, true, false, false, false, false, false};
  return test_bool_function(is_head, test_cases, expected_outputs);
}

bool test_is_snake() {
  const char *test_cases = "wasdWASDx^<v>k";
  const bool expected_outputs[] = {true, true, true, true, true, true, true, true, true, true, true, true, true, false};
  return test_bool_function(is_snake, test_cases, expected_outputs);
}

bool test_body_to_tail() {
  const char *test_cases = "^<v>k";
  const char expected_outputs[] = {'w', 'a', 's', 'd', '?'};
  return test_char_function(body_to_tail, test_cases, expected_outputs);
}

bool test_head_to_body() {
  const char *test_cases = "WASDxk";
  const char expected_outputs[] = {'^', '<', 'v', '>', '?', '?'};
  return test_char_function(head_to_body, test_cases, expected_outputs);
}

bool test_get_next_row() {
  const char *test_cases = "<>^vWASDwasdxk"; 
  const unsigned int expected_outputs[] = {1, 1, 0, 2, 0, 1, 2, 1, 0, 1, 2, 1, 1, 1}; 
  return test_unsigned_function(get_next_row, test_cases, expected_outputs);
}

bool test_get_next_col() {
  const char *test_cases = "<>^vWASDwasdxk"; 
  const unsigned int expected_outputs[] = {0, 2, 1, 1, 1, 0, 1, 2, 1, 0, 1, 2, 1, 1};
  return test_unsigned_function(get_next_col, test_cases, expected_outputs);
}

bool test_customs() {
  if (!test_greater_than_forty_two()) {
    printf("%s\n", "test_greater_than_forty_two failed.");
    return false;
  }
  if (!test_is_vowel()) {
    printf("%s\n", "test_is_vowel failed.");
    return false;
  }
  if (!test_is_tail()) {
    printf("%s\n", "test_is_tail failed");
    return false;
  }
  if (!test_is_head()) {
    printf("%s\n", "test_is_head failed");
    return false;
  }
  if (!test_is_snake()) {
    printf("%s\n", "test_is_snake failed");
    return false;
  }
  if (!test_body_to_tail()) {
    printf("%s\n", "test_body_to_tail failed");
    return false;
  }
  if (!test_head_to_body()) {
    printf("%s\n", "test_head_to_body failed");
    return false;
  }
  if (!test_get_next_row()) {
    printf("%s\n", "test_get_next_row failed");
    return false;
  }
  if (!test_get_next_col()) {
    printf("%s\n", "test_get_next_col failed");
    return false;
  }
  return true;
}

int main(int argc, char *argv[]) {
  init_colors();

  if (!test_and_print("custom", test_customs)) {
    return 0;
  }

  return 0;
}
