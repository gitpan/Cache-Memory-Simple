use strict;
use warnings;
use utf8;
use Test::More;
use Test::Time time => 1;
use Cache::Memory::Simple;

subtest 'get/set' => sub {
    my $cache = Cache::Memory::Simple->new();
    is($cache->get('test'), undef);
    $cache->set('test' => 'abc');
    is($cache->get('test'), 'abc');
    sleep 10;
    is($cache->get('test'), 'abc');
};

subtest 'get/set expiration' => sub {
    my $cache = Cache::Memory::Simple->new();
    is($cache->get('test'), undef);
    $cache->set('test' => 'abc', 3);
    is($cache->get('test'), 'abc');
    sleep 10;
    is($cache->get('test'), undef);
    is($cache->get('test'), undef, 'run twice');
};

subtest 'delete expiration' => sub {
    my $cache = Cache::Memory::Simple->new();
    is($cache->get('test'), undef);
    $cache->set('test' => 'abc', 3);
    is($cache->get('test'), 'abc');
    $cache->delete('test');
    is($cache->get('test'), undef, 'removed');
};

subtest 'purge expired data' => sub {
    my $cache = Cache::Memory::Simple->new();
    is($cache->get('test'), undef);
    $cache->set('short'  => 'live',  3);
    $cache->set('long'   => 'life', 60);
    $cache->set('never'  => 'ending story');
    is($cache->count, 3, 'only three data');
    sleep 10;
    $cache->purge();
    is($cache->count, 2, 'removed short lived');
    is($cache->get('short'), undef);
    is($cache->get('long'),  'life');
    is($cache->get('never'), 'ending story');
};

done_testing;
