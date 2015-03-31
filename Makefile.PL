use inc::Module::Install;
name 'Plack-Middleware-Auth-Digest';
all_from 'lib/Plack/Middleware/Auth/Digest.pm';
readme_from "lib/Plack/Middleware/Auth/Digest.pm";

requires 'Plack';
requires 'Digest::MD5';
requires 'Digest::HMAC_SHA1';

test_requires 'Test::More', 0.88;
test_requires 'HTTP::Request::Common', 0;
test_requires 'LWP::UserAgent', 0;

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t t/*/*/*/*/*.t';
author_tests 'xt';
auto_set_repository;
auto_include;
WriteAll;

