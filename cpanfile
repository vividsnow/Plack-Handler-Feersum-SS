# This file is generated by Dist::Zilla::Plugin::CPANFile v6.014
# Do not edit this file directly. To change prereqs, edit the `dist.ini` file.

requires "Carp" => "0";
requires "Fcntl" => "0";
requires "Feersum" => "0";
requires "Plack::Handler::Feersum" => "0";
requires "Server::Starter" => "0";
requires "Symbol" => "0";
requires "base" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Test::More" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};