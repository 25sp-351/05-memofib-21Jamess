#include <stdio.h>

typedef long long (*long_func_ptr)(int param);

long_func_ptr fibonacci_provider;

long long fibonacci(int of_num) {
    printf(__FILE__ ":%2d   fibonacci(%d) called\n", __LINE__, of_num);

    if (of_num < 2)
        return of_num;

    return (*fibonacci_provider)(of_num - 1) +
           (*fibonacci_provider)(of_num - 2);
}

#define MAX_MEMOIZED 91
#define ARRAY_SIZE (MAX_MEMOIZED + 1)
#define NO_VALUE_YET -1LL

long_func_ptr _original_provider;
long long _memoization_data[ARRAY_SIZE];

long long cache_func(int of_num) {
    printf(__FILE__ ":%2d   cache_func(%d) called\n", __LINE__, of_num);

    if (of_num > MAX_MEMOIZED)
        return (*_original_provider)(of_num);

    if (_memoization_data[of_num] == NO_VALUE_YET)
        _memoization_data[of_num] = (*_original_provider)(of_num);

    return _memoization_data[of_num];
}

long_func_ptr init_cache(long_func_ptr real_provider) {
    for (int ix = 0; ix < ARRAY_SIZE; ix++)
        _memoization_data[ix] = NO_VALUE_YET;

    _original_provider = real_provider;
    return cache_func;
}

int main(int argc, char *argv[]) {
    int test_val;

    if (argc < 2 || sscanf(argv[1], "%d", &test_val) != 1 || test_val < 0) {
        fprintf(stderr, "Usage: %s <non-negative integer>\n", argv[0]);
        return 1;
    }

    fibonacci_provider = init_cache(fibonacci);

    printf("Fibonacci(%d) = %lld\n", test_val, fibonacci_provider(test_val));

    return 0;
}
