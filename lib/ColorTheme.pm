package ColorTheme;

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Color themes

=head1 DESCRIPTION

This document specifies a way to create and use color themes.


=head1 SPECIFICATION VERSION

2


=head1 GLOSSARY

=head2 color theme

Essentially, a mapping of item names and color codes. For example, a color theme
for syntax-coloring JSON might be something like:

 {
   string  => "ffff00",
   number  => "00ffff",
   comma   => "",
   brace   => "",
   bracket => "",
   null    => "ff0000",
   true    => "00ff00",
   false   => "008000",
 }

An application (in this case, a JSON pretty-printer) will consult the color
theme to get the color codes for various items. By using a different color theme
which contains the same item names, a user can change the appearance of an
application or its output (in terms of color) simply by using another compatible
color theme, i.e. color theme which provides color codes for the same items.

=head2 color theme structure

A L<DefHash> which contains the L</color theme> and additional data.

A simple (L<static|/static color theme>) theme has all its information
accessible from the color theme structure.

=head2 color theme class

A Perl module in the C<ColorTheme::*> or C<SOME::APP::ColorTheme::*> namespace
following this specification. A color theme class contains L</color theme
structure> in its C<%THEME> package variable, as well as some required methods
to access the information in the structure.

A simple (L<static|/static color theme>) theme has all its information
accessible from the color theme structure, so client can actually bypass the
methods and access the color theme structure directly. Although it is
recommended to always use the methods to access information in the color theme.

=head2 static color theme

A color theme where all the items are specified in the color theme structure. A
client can by-pass the method and access C<%THEME> directly.

See also: L</dynamic color theme>.

=head2 dynamic color theme

A color theme where one must call C</list_items> to get all the items, because
not all (or any) of the items are specified in the color theme structure.

A dynamic color theme can produce items on-demand or transform other color
themes, e.g. provide a tint or duotone color effect on an existing theme.

When a color theme is dynamic, it must set the property C<dynamic> in the color
theme structure to true.

See also: L</static color theme>.


=head1 SPECIFICATION

=head2 Color theme class

A color theme class must be put in C<ColorTheme::> namespace, or for
application-specific themes, in C<SOME::APP::ColorTheme::*>, where C<SOME::APP>
is an application namespace.

The color theme class must declare a package hash variable named C<%THEME>
containing the L<color theme structure|/Color theme structure>. It also must
provide these methods:

=over

=item * new

Usage:

 my $theme_class = ColorTheme::NAME->new([ %args ]);

Constructor. Known arguments will depend on the particular theme class and must
be specified in the color theme structure under the C<args> key.

=item * list_items

Usage:

 my @item_names = $theme_class->list_items;
 my $item_names = $theme_class->list_items;

Must return list of item names provided by theq theme. Each item has a color
associated with it and the color can be retrieved using L</get_color>.

=item * get_color

Usage:

 my $color = $theme_class->get_color($item_name [ , \%args ]);

Get color for an item. The color can be a single RGB value, e.g. C<ffcc00> or a
DefHash e.g. C<< {fg=>'ffcc00', bg=>'333333', summary=>'...'} >> (all keys
optional).

=back

=head2 Color theme structure

Color theme structure is a L<DefHash> containing these keys:

=over

=item * v

Required. Float. From DefHash. Must be set to 2 (this specification version).

=item * summary

String. Optional. From DefHash.

=item * description

String. Optional. From DefHash.

=item * args

Hash of argument names as keys, and argument specification DefHash as values.
The argument specification resembles that specified in L<Rinci::function>. Some
of the important or relevant properties: C<req>, C<schema>, C<default>.

=item * dynamic

Boolean, optional. Must be set to true if the theme class is dynamic, i.e. the
L</colors> property does not contain all (or even any) of the items of the
theme. Client must call L</list_items> to list all the items in the theme.

=item * colors

Required. Hash of item names as keys and colors as values.

Color can be a single RGB value, e.g. C<ffcc00> or a DefHash e.g. C<<
{fg=>'ffcc00', bg=>'cc0000', ansi_fg=>..., ansi_bg=>..., summary=>..., ...} >>
(all keys optional) or a coderef. The coderef will be supplied arguments of
L</get_color> and is expected to retruen an RGB string or a DefHash.

A DefHash color containing multiple color codes is used to support specifying
foreground/background values or ANSI color codes that are not representable by
RGB, among other things. You can also put summary and additional information in
the DefHash.

Allowing coderef as color allows for flexibility, e.g. for doing gradation
border color, random color, etc.

=back


=head1 HISTORY

L<Color::Theme> is an older specification, superseded by this document.


=head1 SEE ALSO

L<DefHash>
