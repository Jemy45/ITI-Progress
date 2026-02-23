# VMware vSphere Infrastructure Implementation Project

## 📄 Project Documentation

**File**: [OJA.pdf](OJA.pdf)

---

## 🎯 Project Overview

This project documents the end-to-end implementation of a production-grade VMware vSphere 8.0 virtualization infrastructure, built as the final project for the System Administration track at ITI (Information Technology Institute), Alexandria Branch — Intake 46, 2026.

The environment includes a three-node ESXi cluster managed by vCenter Server, fully integrated with a Windows Server Active Directory domain (`iti.local`). A dedicated Linux server was provisioned as NFS shared storage **and joined to the Active Directory domain**, enabling centralized authentication across the entire infrastructure. Advanced features — High Availability (HA), Distributed Resource Scheduler (DRS), vMotion, and Fault Tolerance (FT) — were deployed and verified with real failover tests.

> **Supervised by**: Eng. Ekram  
> **Authors**: Ahmed Hamdy · Omar Soliman · Ahmed Gamal

---

## 🌐 Network & Infrastructure Summary

### Network Parameters

| Parameter       | Value                        |
|----------------|------------------------------|
| Network         | 10.153.153.0 / 255.255.255.0 |
| Primary DNS     | 10.153.153.1 (DC1)           |
| Domain Name     | iti.local                    |

### IP Address Allocation

| Device          | IP Address       | Role                                  |
|----------------|-----------------|---------------------------------------|
| DC1             | 10.153.153.1    | Windows Server Domain Controller + DNS |
| ESXi-Hamdy      | 10.153.153.33   | ESXi Host                             |
| ESXi-Jimmy      | 10.153.153.113  | ESXi Host                             |
| ESXi-Omar       | 10.153.153.232  | ESXi Host                             |
| vCenter Server  | 10.153.153.34   | Centralized vSphere Management        |
| NFS-Storage     | 10.153.153.153  | Linux NFS Shared Storage Server       |

### vMotion Network (per ESXi Host)

| ESXi Host   | vMotion IP       |
|------------|-----------------|
| ESXi-Hamdy  | 10.153.153.80   |
| ESXi-Jimmy  | 10.153.153.82   |
| ESXi-Omar   | 10.153.153.81   |

---

## 🚀 Features Implemented

### 1. Active Directory Integration

A Windows Server was deployed as the Domain Controller for the `iti.local` domain, providing DNS and centralized authentication for the entire vSphere infrastructure.

- **Domain**: `iti.local`
- **All three ESXi hosts** were joined to the `iti.local` domain (DNS configured, FQDN set per host)
- **vCenter Server** was joined to the `iti.local` domain via the vCenter Management Interface (port 5480)
- **Linux NFS Storage Server** was joined to the `iti.local` domain using `realm` and Kerberos authentication (packages: `realmd`, `sssd`, `oddjob`, `adcli`, `samba-common-tools`)
- **Vmware-Admins** security group created in AD with members: Hamdy, Jimmy, Omar — granted Administrator role on ESXi hosts
- Organizational Units created: `ESXi-Hosts`, `Service-Accounts`, `vCenter`, `NFSServer`
- Access control verified: non-group accounts correctly denied access; domain users (e.g., `Jimmy@iti.local`) successfully authenticated with full administrative access

### 2. vCenter Infrastructure Configuration

- Created **OJA DataCenter** as the top-level inventory container
- Created **OJA Cluster** with:
  - **DRS** (Distributed Resource Scheduler): Enabled
  - **vSphere HA** (High Availability): Enabled
  - **vSAN**: Disabled (external NFS storage used instead)
- Added all three ESXi hosts (ESXi-Hamdy, ESXi-Jimmy, ESXi-Omar) to the cluster

### 3. Content Library & VM Templates

- Created a local content library: **"OJA ISO Repo"** stored on Hamdy's DataStore
- Uploaded ISO images (CentOS 6.7, VMware ESXi) to the library
- Created OVF/OVA VM templates in the content library for rapid deployment
- Deployed virtual machines directly from content library templates

### 4. vMotion Network Configuration

A dedicated vMotion virtual switch (`vSwitch1`) with a separate VMkernel port group (`Migration&Storage vSwitch`) was configured on each ESXi host to carry live migration traffic independently from management traffic.

### 5. NFS Shared Storage (Linux Machine joined to Active Directory)

A dedicated Linux server (`10.153.153.153`) was configured from scratch as the centralized NFS shared storage for the cluster:

- Installed `nfs-utils` and enabled the `nfs-server` service
- Created and mounted a **40 GB dedicated partition** at `/shared_storage`
- Configured NFS exports with `sync` and `no_root_squash` options
- Configured the Linux firewall to allow NFS traffic on the `ens160` interface
- **Joined the Linux server to the `iti.local` Active Directory domain** using `realm join` with Kerberos authentication — making it a fully domain-managed storage node alongside the ESXi hosts and vCenter
- Added the NFS share as the **"OJA-NFS-Share-Storage"** datastore in vCenter (NFS v3, 39+ GB)
- Verified by deploying a VM (`OJA Centos VM`) directly onto NFS storage and confirming VM files (`.vmx`, `.vmdk`, `.nvram`) written to the Linux server's `/shared_storage` directory

### 6. Virtual Machine Operations

- **Clone VM to Template**: Created `OJA Centos Template` on NFS storage with Thin Provision disks
- **Clone Template to Content Library**: Stored template in `OJA ISO Repo` for centralized management
- **Clone Existing VM**: Created identical VM copy on Hamdy's DataStore
- **VM Snapshots**: Captured memory-inclusive snapshots (e.g., `OJA CentOS VM Snapshot 2/7/2026`)
- **vMotion (Live Migration)**: Migrated running VMs between ESXi hosts and across datastores with zero downtime

### 7. vSphere High Availability (HA)

- Enabled HA on OJA Cluster with **Host Monitoring** active and **Host Failure Response** set to `Restart VMs`
- **Verified**: A Windows Server VM running on ESXi-Jimmy (`10.153.153.113`) was automatically detected and restarted on ESXi-Hamdy (`10.153.153.33`) after simulating host failure — with no manual intervention required

### 8. Distributed Resource Scheduler (DRS)

- Enabled DRS in **Fully Automated** mode with VM Automation enabled
- **Verified**: When resource contention was detected on ESXi-Jimmy, DRS automatically triggered a live vMotion migration of the Windows Server VM to ESXi-Hamdy — seamlessly, without downtime

### 9. vSphere Fault Tolerance (FT)

- Configured a dedicated VMkernel port (`vmk1`) for **Fault Tolerance logging** traffic (alongside vMotion, MTU 1500)
- Enabled FT on a Windows Server VM, placing the secondary VM on ESXi-Hamdy with disks on NFS storage
- **Verified**: FT status confirmed as `Protected`; after simulating primary host failure on ESXi-Jimmy, the secondary VM on ESXi-Hamdy seamlessly became the new primary — preserving the VM's IP address, DNS name, and workload state with **zero downtime and zero data loss**
- A new secondary VM was automatically created on another available host after failover

---

## 🛠️ Environment Details

| Component       | Details                                      |
|----------------|----------------------------------------------|
| Platform        | VMware vSphere 8.0                           |
| Hypervisor      | VMware ESXi 8 (×3 hosts)                    |
| Management      | VMware vCenter Server 8                      |
| Domain          | iti.local (Windows Server AD)                |
| Storage         | Linux NFS Server (joined to AD domain)       |
| Networking      | Standard Virtual Switches (vSS) per host     |
| Cluster Name    | OJA Cluster (HA + DRS enabled)              |
| Datacenter Name | OJA DataCenter                              |

---

## 📋 Prerequisites

To understand and replicate this project, familiarity with the following is recommended:

- Basic networking (TCP/IP, DNS, subnets)
- Windows Server and Active Directory fundamentals
- Linux command-line administration
- VMware vSphere concepts (ESXi, vCenter, datastores)

---

## 👥 Team

| Name          | Role                   |
|--------------|------------------------|
| Ahmed Hamdy   | Project Team Member    |
| Omar Soliman  | Project Team Member    |
| Ahmed Gamal   | Project Team Member    |

**Supervised by**: Eng. Ekram  
**Track**: System Administration — ITI Alexandria Branch, Intake 46 (2026)

- GitHub: [@Jemy45](https://github.com/Jemy45)
- Email: agml2048@gmail.com

---

*This project was completed as part of the ITI (Information Technology Institute) training program.*
