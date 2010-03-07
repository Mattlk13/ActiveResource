package ActiveResource::Connection;
use common::sense;
use parent qw(Class::Accessor::Lvalue::Fast);
use LWP::UserAgent;
use HTTP::Request;

__PACKAGE__->mk_accessors(qw(site user password));

sub ua {
    LWP::UserAgent->new
}

sub url {
    my $self = shift;
    my $path = shift;

    my $user = $self->user;
    my $pass = $self->password;
    my $url = URI->new($self->site);

    if ($user && $pass) {
        $url->userinfo("${user}:${pass}");
    }
    $url->path($path);

    return $url;
}

sub get {
    my ($self, $path) = @_;

    my $url = $self->url($path);
    return ua->get($url);
}

use YAML;

sub post {
    my ($self, $path, $body) = @_;
    my $url = $self->url($path);

    print STDERR "URL: $url\n";
    my $request = HTTP::Request->new("POST", $url);
    $request->header("Content-Type" => "text/xml");
    $request->content($body);

    print STDERR YAML::Dump($request);

    return ua->request($request);
}

1;
