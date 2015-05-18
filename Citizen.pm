package Citizen;
use Moose;
use Moose::Util::TypeConstraints;

enum Occupation => [qw(diplomat chef shopkeeper)];
subtype 'Attribute', as 'Int', where { $_ >= 0  && $_ <= 10};

has 'name' => (is => 'ro', isa => 'Str', required => '1');
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
1;

sub learn {
	my $self = shift;
	(my $information) = @_;	
	push(@{$self->known_information},$information);
}

1;
