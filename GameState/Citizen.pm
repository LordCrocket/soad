package GameState::Citizen;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::ClassAttribute;
use MooseX::StrictConstructor;
use Log::Log4perl;
use String::Trim;
use Data::Dumper;


use namespace::autoclean;

my $logger = Log::Log4perl->get_logger('citizen');


use overload '""' => "to_string", fallback => 1;
use overload '~~' => "_matching", fallback => 1;
use overload 'eq' => "_matching", fallback => 1;

class_has 'attribute_min' =>( is => 'ro', isa => 'Int',default => 0);
class_has 'attribute_max' =>( is => 'ro', isa => 'Int',default => 10);

enum Occupation => [qw(diplomat chef shopkeeper)];
enum Allegiance => [qw(KGB MI6)];

subtype 'Attribute', as 'Int', where { $_ >= GameState::Citizen->attribute_min  && $_ <= GameState::Citizen->attribute_max};

has 'name' => (is => 'ro', isa => 'Str',writer => '_set_name', initializer => '_trim_and_set_name', required => '1');
has 'age' => (is => 'ro', isa => 'Int', required => '1');
has 'occupation' => (is => 'ro', isa => 'Occupation', required => '1');
has 'loyalty' => (is => 'ro', isa => 'Attribute', required => '1');
has 'financial_status' => (is => 'ro', isa => 'Attribute', required => '1');
has 'social_life' => (is => 'ro', isa => 'Attribute', required => '1');

has 'allegiances' => (
	is => 'ro',
	isa => 'ArrayRef[Allegiance]',
	traits  => ['Array'],
	init_arg => undef,
	required => '1',
	default => sub {[]},
	handles => {
		_push_allegiance  => 'push'
	}
);

has '_known_information' => (
	is  => 'rw',
	isa => 'ArrayRef[GameState::Information]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},
	handles => {
		_push_known_information  => 'push'
	}
);


sub _trim_and_set_name {
	(my $self,my $name) = @_;
	$self->_set_name(trim($name));
}

sub learn {
	(my $self,my $information) = @_;
	$self->_push_known_information($information);
	$logger->debug($self . " has learnt: " . $information);
}

sub add_allegiance {
	(my $self,my $allegiance) = @_;
	$self->_push_allegiance($allegiance);
	$logger->debug($self . " is now loyal to: " . $allegiance);
}

sub to_string {
	(my $self) = @_;
	my $string_rep = $self->name;
	return $string_rep;
}

sub _matching {
	(my $self,my $other) = @_;
	#$logger->debug("Matching: " . $self . " " . $other);
	return $self->name eq $other->name;
}

__PACKAGE__->meta->make_immutable;

1;
