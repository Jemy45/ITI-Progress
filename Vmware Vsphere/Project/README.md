# VMware vSphere Final Project

## 📄 Project Documentation

**File**: [OJA.pdf](OJA.pdf)

---

## 🎯 Project Overview

This document represents the final project for the VMware vSphere training module at ITI (Information Technology Institute). It covers the design, configuration, and implementation of a complete VMware vSphere virtualization environment.

---

## 🏗️ Topics Covered

The project demonstrates hands-on implementation of the following vSphere components and technologies:

### Virtualization Infrastructure
- **VMware ESXi** hypervisor installation and configuration
- **VMware vCenter Server** deployment (appliance-based)
- Building a Software-Defined Data Center (SDDC)

### Compute & Resource Management
- Virtual Machine (VM) creation and management
- CPU and memory allocation with overcommitment strategies
- Thin vs. Thick disk provisioning
- Resource pools and reservations

### Networking
- Virtual Standard Switch (vSS) configuration
- Virtual Distributed Switch (vDS) configuration
- VMkernel port groups for management, vMotion, storage, and fault tolerance traffic
- VLAN configuration and network segmentation

### Storage
- SAN (Storage Area Network) connectivity and zoning
- NAS (Network Attached Storage) with NFS datastores
- VMFS datastore creation, expansion (extend/expand), and management
- Multipath I/O configuration and load balancing

### High Availability & Business Continuity
- **vSphere High Availability (HA)**: Automatic VM restart on host failure
- **vSphere Distributed Resource Scheduler (DRS)**: Automated workload balancing
- **vSphere vMotion**: Live migration of VMs between hosts
- **vSphere Fault Tolerance (FT)**: Zero-downtime protection for critical VMs

### Security & Identity
- Active Directory integration for authentication
- Single Sign-On (SSO) configuration
- Lockdown mode and access control
- VM and vMotion encryption

### Templates & Automation
- VM template creation and management
- Content Libraries (local, shared, and subscribed)
- VM customization specifications

---

## 🛠️ Environment Details

| Component        | Details                                      |
|-----------------|----------------------------------------------|
| Hypervisor       | VMware ESXi 8                                |
| Management       | VMware vCenter Server 8                      |
| Platform         | VMware vSphere 8                             |
| Storage Types    | SAN (Fibre Channel / iSCSI) and NAS (NFS)    |
| Networking       | Standard and Distributed Virtual Switches    |

---

## 📋 Prerequisites

To understand and replicate this project, familiarity with the following is recommended:

- Basic networking concepts (TCP/IP, VLANs, switching, routing)
- Server hardware fundamentals
- Windows Server or Linux system administration basics
- Storage concepts (LUNs, datastores, file systems)

---

## 👤 Author

**Ahmed Gamal**

- GitHub: [@Jemy45](https://github.com/Jemy45)
- Email: agml2048@gmail.com

---

*This project was completed as part of the ITI (Information Technology Institute) training program.*
