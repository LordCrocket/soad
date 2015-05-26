package Citizen;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::ClassAttribute;
use Log::Log4perl;
use String::Trim;

use namespace::autoclean;

my $logger = Log::Log4perl->get_logger('citizen');


use overload '""' => "to_string", fallback => 1;

class_has 'attribute_min' =>( is => 'ro', isa => 'Int',default => 0);
class_has 'attribute_max' =>( is => 'ro', isa => 'Int',default => 10);

enum Occupation => [qw(diplomat chef shopkeeper)];
subtype 'Attribute', as 'Int', where { $_ >= Citizen->attribute_min  && $_ <= Citizen->attribute_max};

has 'name' => (is => 'ro', isa => 'Str',writer => '_set_name', initializer => '_trim_and_set_name', required => '1');
has 'age' => (is => 'ro', isa => 'Int', required => '1');
has 'occupation' => (is => 'ro', isa => 'Occupation', required => '1');
has 'loyalty' => (is => 'ro', isa => 'Attribute', required => '1');
has 'financial_status' => (is => 'ro', isa => 'Attribute', required => '1');
has 'social_life' => (is => 'ro', isa => 'Attribute', required => '1');

has 'known_information' => (
	is  => 'rw',
	isa => 'ArrayRef[Information]',
	default => sub {[]}
	);


sub _trim_and_set_name {
	(my $self,my $name) = @_;
	$self->_set_name(trim($name));
}

sub learn {
	(my $self,my $information) = @_;
	$logger->debug($self . " has learnt: " . $information);
	push(@{$self->known_information},$information);
}

sub to_string {
	my $self = shift;
	my $string_rep = $self->name;
	return $string_rep;
}

__PACKAGE__->meta->make_immutable;

1;
