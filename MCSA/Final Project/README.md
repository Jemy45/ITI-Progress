# MCSA Final Project - Windows Server System Administration

## 📋 Project Overview

This comprehensive Windows Server project demonstrates enterprise-level Active Directory implementation and system administration capabilities. The project was completed as part of the ITI Alexandria Windows Server course (Intake 46) and showcases real-world network infrastructure design and implementation.

**Supervised by:** Eng. Mohamed AboSehly

**Systems Engineering Team:**
- Mostafa Masoud
- Assem Ragab
- Ahmed Gamal
- Roumaysaa Samy
- Mariam Ali

**Project Year:** 2026

## 🎯 Project Objectives

This project implements a comprehensive Windows Server Active Directory infrastructure that demonstrates:

1. **Multi-Domain Active Directory Forest** - Root domain (ITI.LOCAL) with two child domains (ALEX.ITI.LOCAL and ISM.ITI.LOCAL)
2. **Multiple Domain Controllers** - Six domain controllers with different roles for redundancy and specialized services
3. **User Access Control Policies** - Computer-specific login restrictions, time-based access control, and system resource restrictions
4. **Read-Only Domain Controller (RODC)** - Branch office scenario implementation with password replication policies
5. **Group Policy Objects (GPO)** - Automated software deployment and policy enforcement across the domain
6. **Administrative Delegation** - Limited administrative rights without full domain administrator privileges
7. **Roaming User Profiles** - Seamless user experience across multiple workstations
8. **Windows Deployment Services (WDS)** - Automated workstation deployment for efficient provisioning
9. **External Network Services** - DNS, DHCP, and Web Server infrastructure
10. **Remote Access Services** - FTP and RDP configuration with security controls

## 🏗️ Infrastructure Architecture

### Domain Structure

```
ITI.LOCAL (Root Domain)
├── ALEX.ITI.LOCAL (Child Domain)
└── ISM.ITI.LOCAL (Child Domain)
```

### Domain Controllers

| Server | Role | Services |
|--------|------|----------|
| **DC1** | Primary Domain Controller | DNS, AD DS |
| **DC2** | Additional Domain Controller | Redundancy |
| **DC3** | Read-Only Domain Controller (RODC) | Branch Office Authentication |
| **DC4** | Child Domain Controller | ALEX.ITI.LOCAL |
| **DC5** | Child Domain Controller | ISM.ITI.LOCAL |
| **DC6** | Windows Deployment Services | WDS, DHCP |

### Remote Server (External to Domain)

Standalone server providing:
- **IIS Web Server** - Public web hosting
- **DNS Services** - Secondary zone configuration
- **DHCP Server** - IP address management
- **FTP Server** - Secure file transfer with user isolation
- **RDP Access** - Remote desktop services

## 💡 Key Features Implemented

### 1. Active Directory Configuration

- **Forest and Domain Hierarchy**: Three-domain structure with parent-child relationships
- **Organizational Units (OUs)**: Structured organization for users and computers
- **Trust Relationships**: Automatic two-way transitive trusts between domains

### 2. User Access Controls

- **Login Restrictions**: Computer-specific and time-based access control
  - User A@ITI.local restricted to PC1 only
  - Login prohibited on Fridays for specific accounts
- **RODC Password Replication**: Selective password caching for branch offices
  - User help@ITI.local allowed on RODC authentication

### 3. Group Policy Implementations

- **System Restrictions for User c@ITI.local**:
  - Control Panel access removed
  - Removable storage and flash memory blocked
  - Mandatory desktop wallpaper (ITI logo)
- **Software Deployment**: Automated VLC Media Player installation via GPO
- **Remote Desktop Configuration**: GPO-based RDP enablement

### 4. Administrative Features

- **Delegation of Control**: User B@iti.local granted limited administrative rights
- **Roaming Profiles**: User A@Ism.ITI.Local profile follows across workstations
- **Bulk User Management**: 50 user accounts created via batch script

### 5. Network Services

- **DNS Configuration**:
  - Primary zones on domain controllers
  - Secondary zone replication
  - Forward lookup zones for web services
- **DHCP Implementation**:
  - Scoped IP address ranges
  - Option 66 and 67 for WDS PXE boot
  - Lease management and reservations

### 6. Windows Deployment Services (WDS)

- **Automated OS Deployment**: Network-based Windows installation
- **PXE Boot Configuration**: Pre-boot execution environment setup
- **Image Management**:
  - Boot image (boot.wim)
  - Install image (install.wim)
- **Mass Deployment**: Efficient provisioning for multiple workstations

### 7. File Transfer Protocol (FTP)

- **User Isolation**: Each user restricted to their own directory
- **Security Controls**:
  - Users can create their own folders
  - Users cannot access other users' folders
  - Anonymous access disabled

## 📁 Technologies & Services

- **Active Directory Domain Services (AD DS)**
- **DNS (Domain Name System)**
- **DHCP (Dynamic Host Configuration Protocol)**
- **Group Policy Objects (GPO)**
- **Windows Deployment Services (WDS)**
- **Internet Information Services (IIS)**
- **File Transfer Protocol (FTP)**
- **Remote Desktop Protocol (RDP)**
- **Read-Only Domain Controller (RODC)**

## 📄 Project Documentation

The complete project documentation is available in [MCSA_FinalProject.pdf](MCSA_FinalProject.pdf), which includes:

- Detailed implementation steps with screenshots
- Configuration procedures for each service
- Verification and testing results
- Network topology diagrams
- Troubleshooting notes

## 🎓 Skills Demonstrated

This project showcases proficiency in:

- Enterprise Active Directory design and implementation
- Multi-domain forest configuration
- Group Policy management and deployment
- Windows Server role installation and configuration
- Network services implementation (DNS, DHCP, WDS)
- Security policy enforcement
- User and computer management at scale
- Remote access and file sharing services
- Automated deployment solutions
- Documentation and technical writing

## 🔍 Use Cases

The implemented infrastructure addresses real-world scenarios:

- **Branch Office Connectivity**: RODC implementation for remote locations
- **Centralized Management**: GPO-based policy enforcement across the enterprise
- **Rapid Deployment**: WDS for quick workstation provisioning
- **User Mobility**: Roaming profiles for seamless multi-workstation experience
- **Security Controls**: Granular access restrictions and administrative delegation
- **Service Availability**: Multiple domain controllers for redundancy

## 📝 Notes

- This project was completed as part of the ITI (Information Technology Institute) curriculum
- All configurations follow Microsoft best practices for enterprise environments
- The project demonstrates scalability and redundancy principles
- Screenshots and detailed verification steps are included in the PDF documentation

---

**For detailed implementation steps, configuration guides, and screenshots, please refer to [MCSA_FinalProject.pdf](MCSA_FinalProject.pdf)**

*ITI Alexandria - Windows Server Course Project © 2026*