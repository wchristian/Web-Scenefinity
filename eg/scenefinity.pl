#!/usr/bin/perl

use strictures;
use lib '../lib';
use CGI::Carp qw(fatalsToBrowser);
use Carp::Always;
use Web::Scenefinity;
Web::Scenefinity->run_if_script;
