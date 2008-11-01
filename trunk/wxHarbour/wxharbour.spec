#
# wxharbour.spec
#
# (C) Teo Fonrouge 2008
#

%define name        wxHarbour
%define cname       wxHarbour
%define version     0.3.92
%define release     2
%define hbcompiler  harbour

Summary:    A portable GUI toolkit for [x]Harbour using wxWidgets
Name:       %{name}
Version:    %{version}
Release:    %{release}
License:    LGPL
Group:      Development/Libraries
Vendor:     http://sourceforge.net/projects/wxharbour
Source:     %{name}-%{version}-%{release}.src.tar.gz
Packager:   Teo Fonrouge <teo@windtelsoft.com>
Requires:   %{hbcompiler}
Provides:   %{name}
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{cname} is [x]Harbour (a 100% Clipper compatible compiler) language (www.xharbour.org, www.harbour-project.org) bindings for wxWidgets (www.wxwidgets.org), providing a portable GUI toolkit for [x]Harbour.

Install %{cname} if you want to give a powerfull multiplatform GUI
to your [x]Harbour applications.

(for %{hbcompiler} compiler version)

%prep
%setup -n %{name}-%{version}-%{release}

#%patch -p1 -b .buildroot

%build
make HBCOMPILER=%{hbcompiler} HBBUILD=release

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT
echo "Installing on $RPM_BUILD_ROOT..."
make DESTDIR=$RPM_BUILD_ROOT install

%files
%defattr(-,root,root)
/usr/local/include/defs.ch
/usr/local/include/dialog.ch
/usr/local/include/event.ch
/usr/local/include/property.ch
/usr/local/include/raddox.ch
/usr/local/include/toplevel.ch
/usr/local/include/xerror.ch
/usr/local/include/wx.ch
/usr/local/include/wxh/filedlg.ch
/usr/local/include/wxh/textctrl.ch
/usr/local/include/wx_hbcompat.ch
/usr/local/include/wxharbour.ch
/usr/local/lib/libwxHarbour-unicode.a
