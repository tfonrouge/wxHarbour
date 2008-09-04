#
# wxharbour.spec
#

%define name      wxharbour
%define cname     wxHarbour
%define version   0.3.92

Summary:    A portable GUI toolkit for [x]Harbour using wxWidgets
Name:       %{name}
Version:    %{version}
Release:    1
License:    LGPL
Group:      Development/Libraries
Vendor:     http://sourceforge.net/projects/wxharbour
Source:     %{name}-%{version}.src.tar.gz
Packager:   Teo Fonrouge <teo@windtelsoft.com>
Requires:   harbour
Provides:   %{name}
BuildRoot:  %{_tmppath}/%{name}-%{version}-root
#BuildRoot:  /var/tmp/%{name}-%{version}-root

%description
%{cname} is [x]Harbour (a 100% Clipper compatible compiler) language (www.xharbour.org, www.harbour-project.org) bindings for wxWidgets (www.wxwidgets.org), providing a portable GUI toolkit for [x]Harbour.

Install %{cname} if you want to give a powerfull multiplatform GUI
to your [x]Harbour applications.

%prep
%setup -c %{name}-%{version}

#%patch -p1 -b .buildroot

%build
make

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install

%files
%defattr(-,root,root)
/usr/local/include/defs.ch
/usr/local/include/event.ch
/usr/local/include/property.ch
/usr/local/include/wx.ch
/usr/local/include/wxharbour.ch
/usr/local/lib/libwxHarbour-unicode.a
