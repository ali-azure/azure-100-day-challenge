# Day 42 — IP Address Plan

| Subnet | CIDR Range | Start Address | End Address | Total Addresses | Azure Reserved | Usable Addresses |
|---|---|---|---|---:|---:|---:|
| web-subnet | 10.1.1.0/24 | 10.1.1.0 | 10.1.1.255 | 256 | 5 | 251 |
| app-subnet | 10.1.2.0/26 | 10.1.2.0 | 10.1.2.63 | 64 | 5 | 59 |
| db-subnet | 10.1.3.0/27 | 10.1.3.0 | 10.1.3.31 | 32 | 5 | 27 |
| mgmt-subnet | 10.1.4.0/28 | 10.1.4.0 | 10.1.4.15 | 16 | 5 | 11 |
| AzureBastionSubnet | 10.1.5.0/26 | 10.1.5.0 | 10.1.5.63 | 64 | 5 | 59 |