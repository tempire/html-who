use strict;
use warnings;
use Test::More;
use HTML::Who;

my $t = HTML::Who->new;
ok $t->has_children(a => []);
ok $t->has_children(a => href => 'http://' => 'alt' => ['link']);
ok $t->has_no_children(a => href => 'http://');
ok $t->has_no_children(a => href => 'http://' => 'alt');

is $t->open_tag(a => href => 'http://', rel => 'next', 'alt') =>
  '<a href="http://" rel="next" alt>';
is $t->open_tag(a => href => 'http://', rel => 'next') =>
  '<a href="http://" rel="next">';
is $t->open_tag(a => href => 'http://', rel => 'next', border => 0) =>
  '<a href="http://" rel="next" border="0">';
is $t->open_tag(a => href => 'http://', border => 0) =>
  '<a href="http://" border="0">';
is $t->close_tag(a => href => 'http://' => 'alt') => '</a>';

is $t->enclosed_tag(a => href => 'http://' => 'alt') =>
  '<a href="http://" alt />';
is $t->enclosed_tag(a => href => 'http://' => border => 0) =>
  '<a href="http://" border="0" />';
is $t->text_node('text') => 'text';

is $t->examine(h1 => ['hello']) => '<h1>hello</h1>';
is $t->examine(a => href => 'http://' => 'alt') => '<a href="http://" alt />';
is $t->examine(a => href => 'http://' => 'alt' => ['link']) =>
  '<a href="http://" alt>link</a>';
is $t->examine(
  a   => href   => 'http://',
  rel => 'next' => [img => src => 'http://', border => 0]
) => '<a href="http://" rel="next"><img src="http://" border="0" /></a>';

is $t->html(
  [a => href => 'http://' => 'alt' => [img => src => 'http://', border => 0]],
  [a => href => 'http://' => 'alt' => [img => src => 'http://', border => 0]]
  ) =>
  '<a href="http://" alt><img src="http://" border="0" /></a><a href="http://" alt><img src="http://" border="0" /></a>';

done_testing;
