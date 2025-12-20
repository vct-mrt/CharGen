Name:           chargen
Version:        1.0.0
Release:        1%{?dist}
Summary:        Random character generator

License:        GPLv3+
URL:            https://github.com/vct-mrt/CharGen
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc
BuildRequires:  make

%description
CharGen is a command-line utility that generates random characters
based on specified criteria. It supports numeric, alphabetic, and
special characters with various customization options.

Features:
 - Generate random alphanumeric strings
 - Customize character sets (numbers, letters, special chars)
 - Control case (uppercase/lowercase)
 - Lightweight and fast

%prep
%setup -q

%build
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=%{buildroot} PREFIX=%{_prefix}

%files
%license LICENSE
%doc README.md
%{_bindir}/chargen
%{_mandir}/man1/chargen.1*

%changelog
* Fri Dec 20 2025 vct-mrt <martinetti.victor11@gmail.com> - 1.0.0-1
- Initial RPM release
- Random character generator with multiple options
- Support for numeric, alphabetic, and special characters
