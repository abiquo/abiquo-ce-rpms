Name:           abiquo-aim
BuildRequires:  gcc-c++ thrift-cpp-devel boost-devel curl-devel libvirt-devel 
Requires:	libvirt
Version:        1.6.5
Release:        3
Url:            http://www.abiquo.com/
License:        BSD(or similar)
Group:          System/Management
Summary:        Abiquo Cloud Node Agent
Source:         %{name}-%{version}.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source1:	abiquo-aim.ini
Source2:	abiquo-aim.init

%description
Summary:        Abiquo Cloud Node Agent


Authors:
--------
    Abiquo Development Team

%prep
%setup -q

%build
CPATH=/usr/include/thrift make

%install
mkdir -p $RPM_BUILD_ROOT/%{_sbindir}/
mkdir -p $RPM_BUILD_ROOT/%{_sysconfdir}/rc.d/init.d
cp $RPM_BUILD_DIR/%{name}-%{version}/src/aim $RPM_BUILD_ROOT/%{_sbindir}/abiquo-aim
cp %{SOURCE1} $RPM_BUILD_ROOT/%{_sysconfdir}/abiquo-aim.ini
cp %{SOURCE2} $RPM_BUILD_ROOT/%{_sysconfdir}/rc.d/init.d/abiquo-aim

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_sbindir}/abiquo-aim
%{_sysconfdir}/abiquo-aim.ini
%{_sysconfdir}/rc.d/init.d/abiquo-aim

%post
/sbin/chkconfig --add abiquo-aim

%changelog
* Thu Sep 09 2010 Sergio Rubio <srubio@abiquo.com> 1.6.5-3
- Added config file
- Added init script

* Thu Sep 09 2010 Sergio Rubio <srubio@abiquo.com> 1.6.5-2
- Fixed deps

* Thu Sep 09 2010 Sergio Rubio <srubio@abiquo.com> 1.6.5-1
- Initial Release
