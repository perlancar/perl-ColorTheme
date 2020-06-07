package ColorTheme;

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Color theme class and color theme structure

=head1 DESCRIPTION

This document specifies ColorTheme classes, classes that contain color themes.


=head1 SPECIFICATION VERSION

2


=head1 GLOSSARY

=head2 Color theme structure

C<%THEME> package variable declared in the color theme class, containing the
list of colors.

=head2 Static theme

A theme where all the items are specified in the C<%THEME> color theme
structure. For these themes, a client can by-pass the method and access
C<%THEME> directly.


=head1 SPECIFICATION

=head2 Color theme class

A color theme class must be put in C<ColorTheme::> namespace, or for
application-specific themes, in C<YOUR::APP::ColorTheme::*>, where C<YOUR::APP>
is your application namespace.

The color theme class must declare a package hash variable named C<%THEME>
(color theme structure). It is a L<DefHash> with C<v> set to 2 (this
specification version). See L</Color theme structure> for more details.

Color theme class must also provide these methods:

=over

=item * new

Usage:

 my $theme_class = ColorTheme::NAME->new([ %args ]);

Constructor. Known arguments will depend on the particular theme class and must
be specified in the color theme structure under the C<args> key.

=item * get_color_list

Usage:

 my @item_names = $theme_class->get_color_list;
 my $item_names = $theme_class->get_color_list;

Must return list of item names in this theme. Each item has a color associated
with it and the color can be retrieved using L</get_color>.

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

Required. Float. Must be set to 2 (this specification version).

=item * summary

String. Optional. From DefHash.

=item * description

String. Optional. From DefHash.

=item * dynamic

Boolean, optional. Must be set to true if the theme class is not static, i.e.
the L</colors> property does not contain all (or even any) of the items of the
theme. Client must call L</get_color_list> to list all the items in the theme.

=item * colors

Required. Hash of item names as keys and colors as values.

Color can be a single RGB value, e.g. C<ffcc00> or a DefHash e.g. C<<
{fg=>'ffcc00', bg=>'cc0000', ansi_fg=>..., ansi_bg=>..., summary=>..., ...} >>
(all keys optional) or a coderef. The coderef will be supplied arguments of
L</get_color> and is expected to retruen an RGB string or a DefHash.

Multiple color codes in the DefHash color are used to support
foreground/background values or ANSI color codes that are not representable by
RGB, among other things.

Allowing coderef as color allows for flexibility, e.g. for doing gradation
border color, random color, etc.

=back


=head1 HISTORY

L<Color::Theme> is an older specification, superseded by this document.


=head1 SEE ALSO

L<DefHash>
