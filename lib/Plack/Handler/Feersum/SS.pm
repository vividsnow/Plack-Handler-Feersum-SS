# ABSTRACT: Server::Starter adapter for Feersum Plack handler
package Plack::Handler::Feersum::SS;

use strict;
use warnings;
use base 'Plack::Handler::Feersum';
use Feersum;
use Server::Starter 'server_ports';
use Carp 'croak';
use Symbol 'geniosym';
use Fcntl qw'F_GETFL F_SETFL O_NONBLOCK';

# redefining (origins: Feersum::Runner, Plack::Handler::Feersum)
sub _prepare {
    my $self = shift;
    delete $self->{quiet} if delete $self->{verbose};
    my %ports = %{server_ports()};
    croak "Feersum doesn't support none/multiple listen directives yet" unless %ports == 1;
    my ($port, $fd) = each %ports;
    open(my $sock = geniosym, "<&=", $fd) || croak $!;
    my $flags = fcntl($sock, F_GETFL, 0) or croak $!;
    fcntl($sock, F_SETFL, $flags | O_NONBLOCK) || croak $!;
    print "Feersum [$$] listening on $port fd=$fd\n" unless $self->{quiet};
    $self->{sock} = $sock;
    $self->{listen} = [$port];
    my $f = $self->{endjinn} = Feersum->endjinn;
    $f->use_socket($sock);
    $self->{pre_fork} = delete $self->{options}{pre_fork} if $self->{options};
    $self->{server_ready}->({
        qw'server_software Feersum',
        $port =~ m/^(?:(.+?):|)([0-9]+)$/ ? (host => $1//0, port => $2) : (host => 'unix/', port => $port)
    }) if $self->{server_ready};
    return;
}

1;
