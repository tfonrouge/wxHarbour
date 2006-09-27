#
# wxharbour.spec
#

%define name      wxharbour
%define cname     wxHarbour
%define version   0.1.0

Summary:    A portable GUI toolkit for [x]Harbour
Name:       %{name}
Version:    %{version}
Release:    1
License:    LGPL
Group:      Development/Libraries
Vendor:     http://sourceforge.net/projects/wxharbour
Source:     %{name}-%{version}.src.tar.gz
Packager:   Teo Fonrouge <teo@windtelsoft.com>
Requires:   xharbour
Provides:   %{name}
BuildRoot:  /tmp/%{name}-%{version}-buildroot

%description
%{cname} is [x]Harbour (a 100% Clipper compatible compiler) language (www.xharbour.org, www.harbour-project.org) bindings for wxWidgets (www.wxwidgets.org), providing a portable GUI toolkit for [x]Harbour.

Install %{cname} if you want to give a powerfull multiplatform GUI
to your [x]Harbour applications.

%prep
%setup
%build
make
%install
%files
