## Contributing

If you want to contribute? If you have some ideas or critics, just open an issue, here on github. If you want to get your hands dirty, you can fork this repo. But note: **If you write code, don't forget to write tests.** And then make a pull request. I'll be happy to see what's coming.

## Setup
You will need a couple tools to work on this repo:
- lua 5.1+
- [luarocks](https://luarocks.org/)
- [busted](http://olivinelabs.com/busted/)

## Tests
There are 2 types of tests in this repo, unit and functional. Unit tests tests each unit of code, which in most cases is each function. Functional tests are integration tests, so they are examples that run through behaviour of how many parts of code interact. Most changes will require both types of tests to be added to ensure that your functionality does not break in the future.

All tests can simply be run by using the `luarocks test` command.

## Coverage
Each PR is setup to run a coverage report. If you would like to do so locally, you will need:

- `luarocks install luacov`
- `luarocks install luacov-reporter-lcov`

And then you will be able to run `luarocks test -- --coverage` and it will generate a coverage report for you.
