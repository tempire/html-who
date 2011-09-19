package HTML::Who;
use strict;
use warnings;

sub new {
  return bless {} => shift;
}

sub html {
  my $self = shift;

  return join '', map $self->examine(@$_) => @_;
}

# for one element
sub examine {
  my $self = shift;

  # tag - base case (<img src="image.png" />)
  return $self->enclosed_tag(@_) if $self->has_no_children(@_);

  # descend into child, wrapped with tag
  return
      $self->open_tag(@_)       # <a href="http://mojolicio.us">
    . $self->examine(@{+pop})     # children: arrayref with text node or element
    . $self->close_tag(@_);     # </a>
}

sub open_tag {
  my $self = shift;

  # tag name
  my $tag = '<' . shift;

  # attributes
  for (my $i = 0; @_ > 1; $i = $i + 2) {
    $tag .= sprintf(' %s="%s"', shift, shift);
  }

  # unpaired keys, 'checked' in (<input type="checkbox" checked />)
  $tag .= ' ' . shift if @_;

  return $tag . '>';
}

sub close_tag {
  my $self = shift;

  return '</' . shift . '>';
}

sub text_node {
  return pop;
}

sub enclosed_tag {
  my $self = shift;

  # text node
  return $self->text_node(shift) if @_ == 1;

  my $tag = $self->open_tag(@_);
  $tag = substr $tag, 0, -1;
  $tag .= ' />';

  return $tag;
}

sub has_children {
  return 1 if ref pop eq 'ARRAY';
}

sub has_no_children {
  return !shift->has_children(pop);
}

1;

=head1 NAME

HTML::Who - Perl version of basic cl-who functionality

=head1 DESCRIPTION

L<HTML::Who> serializes data structures similiar to Common Lisp's cl-who to HTML.

=head1 USAGE

  HTML::Who->new->html(
    [h1 => 'hello'],
    [a => href => 'http://mojolicio.us', class => 'nav',
      [img => src => 'image.png']],
    [a => href => 'http://mojocasts.com', ['screencasts']
  );

  # Serializes to (without line-breaks)

  <h1>hello</h1>
  <a href="http://mojolicio.us" class="nav">
    <img src="image.png" />
  </a>
  <a href="http://mojocasts.com">screencasts</a>

=head1 METHODS

=head2 html

Accepts list of arrayrefs, and outputs xml/html without linefeeds.

The following form is accepted:

  [tag => attribute_name => attribute_value]

=over 2

=item * Multiple attributes:

=back

  [tag => 
    attribute_name => attribute_value,
    attribute_name => attribute_value]

=over 2

=item * Attributes with children:

=back

  [tag => attribute_name => attribute_value => 
    [anothertag => attribute_name => attribute_value]]

=over 2

=item * Children may also be text nodes:

=back

  [a => href => 'http://mojolicio.us', ['hello']

=over 2

Serializes to:

=back

  <a href="http://mojolicio.us">hello</a>

=head1 DEVELOPMENT

L<http://github.com/tempire/html-who>
