requires "DBIx::Class::Core" => "0";
requires "DBIx::Class::DeploymentHandler" => "0";
requires "DBIx::Class::Helper::ResultSet::Random" => "0";
requires "DBIx::Class::ResultSet" => "0";
requires "DBIx::Class::Schema::Config" => "0";
requires "Data::Dumper" => "0";
requires "File::ShareDir::ProjectDistDir" => "0";
requires "HTTP::Tiny" => "0";
requires "IO::All" => "0";
requires "IO::All::HTTP" => "0";
requires "JSON" => "0";
requires "List::Util" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "Moose" => "0";
requires "MooseX::AttributeShortcuts" => "0";
requires "MooseX::Getopt" => "0";
requires "Scalar::Util" => "0";
requires "Sub::Exporter::Simple" => "0";
requires "Text::Xslate" => "0";
requires "Try::Tiny" => "0";
requires "Web::Simple" => "0";
requires "XML::Twig" => "0";
requires "YAML" => "0";
requires "base" => "0";
requires "perl" => "5.006";
requires "strictures" => "0";

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::InDistDir" => "0";
  requires "Test::More" => "0";
  requires "lib" => "0";
  requires "parent" => "0";
  requires "perl" => "5.006";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::ShareDir::Install" => "0.06";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::More" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Version" => "1";
};
