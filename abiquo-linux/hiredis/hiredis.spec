Summary: hiredis
Name: hiredis
Version: 0.0.20101005
Release: 1
License: BSD
Group: Applications/Multimedia
URL: http://github.com/antirez/hiredis
Source0: hiredis-%{version}.tar.gz
Patch1: hiredis-c++.patch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: gcc, make
Provides: hiredis

%description
Minimalistic C client for Redis 

%prep
%setup

%patch1 -p1

%build
%{__make}

%install
%{__rm} -rf %{buildroot}
mkdir -p %{buildroot}%{_libdir}
%{__install} -Dp -m 0755 libhiredis.so %{buildroot}%{_libdir}/libhiredis.so
%{__install} -Dp -m 0755 hiredis.h %{buildroot}%{_includedir}/hiredis/hiredis.h
%{__install} -Dp -m 0755 sds.h %{buildroot}%{_includedir}/hiredis/sds.h

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%{_libdir}/
%{_includedir}/

%changelog
* Tue Oct 05 2010 - Sergio Rubio <srubio@abiquo.com> 0.0.20101005
- Initial release

