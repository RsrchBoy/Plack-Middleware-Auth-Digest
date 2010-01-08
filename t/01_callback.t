use strict;
use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use LWP::UserAgent;

$Plack::Test::Impl = "Server"; # to use LWP::Authen::Digest

my $username = 'admin';
my $password = 's3cr3t';
my %passwords = ($username => $password);

my $realm    = 'restricted, area';

my $app = sub { return [ 200, [ 'Content-Type' => 'text/plain' ], [ "Hello $_[0]->{REMOTE_USER}" ] ] };
$app = builder {
    enable 'Auth::Digest', realm => $realm, authenticator => sub { $passwords{$_[0]} }, secret => "foo";
    $app;
};

my $ua = LWP::UserAgent->new;

test_psgi ua => $ua, app => $app, client => sub {
    my $cb = shift;

    my $res = $cb->(GET '/');
    is $res->code, 401;

    my $req = GET "http://localhost/";
    $ua->add_handler(request_prepare => sub {
        my($req, $ua, $h) = @_;
        $realm =~ tr/,/;/; # LWP bug
        $ua->credentials($req->uri->host_port, $realm, $username, $password);
    });

    $res = $cb->($req);
    is $res->code, 200;
    is $res->content, "Hello admin"
};

done_testing;
