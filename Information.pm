package Information;
use Moose;
use MooseX::ABC;


has 'title' => (is => 'ro', isa => 'Str', required => '1');
has 'desc' => (is => 'ro', isa => 'Str', required => '0');

1;
