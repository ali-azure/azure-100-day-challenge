# Day 29 — Create a Conditional Access Policy Requiring MFA
### Azure 100 Days of Cloud Challenge — Ali Aden

## Overview

In this challenge, I implemented a Microsoft Entra Conditional Access policy that requires Multi-Factor Authentication (MFA) for users accessing cloud applications. The policy was configured in Report-only mode to validate the configuration before enforcement and demonstrate a key identity security control used in Azure environments.

Conditional Access is Microsoft's identity-based security control that evaluates sign-in requests and applies access requirements such as MFA. This challenge demonstrates how organizations can strengthen identity security, reduce the risk of account compromise, and implement Zero Trust security principles.

---

## Technologies Used

- Microsoft Entra ID
- Conditional Access
- Multi-Factor Authentication (MFA)
- Microsoft Graph API
- Azure Cloud Shell
- Azure CLI

---

## Architecture Diagram

```text
┌─────────────────────────────┐
│      Microsoft Entra ID     │
│   Identity & Access Mgmt    │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│  Conditional Access Policy  │
│ "Require MFA for All Users" │
└──────────────┬──────────────┘
               │
     ┌─────────┼─────────┐
     │         │         │
     ▼         ▼         ▼
┌─────────┐ ┌─────────┐ ┌─────────────┐
│All Users│ │Excluded │ │ All Cloud   │
│         │ │ Account │ │    Apps     │
└────┬────┘ └────┬────┘ └──────┬──────┘
     │           │             │
     └───────────┼─────────────┘
                 │
                 ▼
┌─────────────────────────────┐
│      Sign-In Attempt        │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│ Conditional Access Engine   │
│ Evaluates Policy Conditions │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│      Grant Access Rule      │
│      Require MFA            │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│      Report-Only Mode       │
│  Evaluated, Not Enforced    │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│ Microsoft Graph Validation  │
│ Azure Cloud Shell Query     │
└─────────────────────────────┘
```

This architecture demonstrates how Microsoft Entra Conditional Access evaluates sign-in requests, applies MFA requirements, excludes administrative accounts from enforcement, and allows policy validation before production deployment.

---

## Implementation Steps

### Step 1: Access Conditional Access

Navigate to:

```text
Microsoft Entra ID
 └── Protection
      └── Conditional Access
```

Create a new policy named:

```text
Require MFA for All Users
```

### Step 2: Configure User Assignments

Under **Users**:

Include:

```text
✓ All Users
```

Exclude:

```text
✓ Administrative Account
```

This prevents accidental administrative lockout during testing.

### Step 3: Configure Target Resources

Under **Target Resources**:

```text
Cloud apps
 └── Include
      └── All cloud apps
```

This ensures the policy applies across the tenant.

### Step 4: Configure Grant Controls

Under **Grant**:

```text
Grant Access
✓ Require multifactor authentication
```

Control configuration:

```text
Require all selected controls
```

### Step 5: Configure Policy Mode

Set policy state to:

```text
Report-only
```

This allows testing and impact analysis without enforcing MFA requirements.

### Step 6: Create the Policy

Review the configuration and create the policy.

| Setting | Value |
|----------|----------|
| Policy Name | Require MFA for All Users |
| Users | All Users |
| Excluded Identities | 1 Administrative Account |
| Resources | All Cloud Apps |
| Grant Control | Require MFA |
| State | Report-only |

---

## Validation

### Validation 1 — Conditional Access Policy List

Verified the policy appears in the Conditional Access policy list.

Confirmed:

- Policy Name: Require MFA for All Users
- State: Report-only

**Screenshot**

```text
screenshots/01-conditional-access-policy-list.png
```

### Validation 2 — Policy Details

Verified:

- Report-only state
- All Users assignment
- All Resources assignment
- Require MFA grant control
- Administrative account exclusion

**Screenshot**

```text
screenshots/02-conditional-access-policy-details.png
```

### Validation 3 — Microsoft Graph API Validation

Used Microsoft Graph API through Azure Cloud Shell to verify the policy exists and is configured correctly.

Command:

```bash
az rest --method GET \
  --url "https://graph.microsoft.com/beta/identity/conditionalAccess/policies" \
  --query "value[].{Name:displayName,State:state}"
```

Output:

```json
[
  {
    "Name": "Require MFA for All Users",
    "State": "enabledForReportingButNotEnforced"
  }
]
```

**Screenshot**

```text
screenshots/03-cli-policy-validation.png
```

---

## Security Benefits

- Stronger identity protection
- Reduced account takeover risk
- Centralized MFA enforcement
- Consistent access control across applications
- Improved Zero Trust security posture
- Better visibility into policy impact before enforcement
- Safer deployment through Report-only testing

---

## What I Learned

- How Conditional Access evaluates user sign-in requests
- How to configure MFA as a grant control
- How Report-only mode allows safe policy testing
- Why MFA is critical for protecting cloud identities
- How to prevent administrative lockout using exclusions
- How Microsoft Graph API can be used to validate Conditional Access policies
- How Conditional Access supports Zero Trust security models
- How Microsoft Entra licensing impacts Conditional Access capabilities

---

## Key Notes

Conditional Access requires Microsoft Entra ID Premium P1 or P2 licensing.

A separate Microsoft Entra ID P2 trial tenant was used to complete this challenge because Conditional Access policies are not available in Microsoft Entra Free.

A dedicated administrative account was excluded from the policy to prevent accidental lockout during testing, following Microsoft Conditional Access best practices.
