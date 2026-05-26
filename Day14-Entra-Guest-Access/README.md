# 📘 Day 14 — Configure Guest User Access & External Collaboration Settings

**Azure 100 Days of Cloud Challenge — Ali Aden**

---

## 📌 Overview  
Today I invited an external guest user into my Microsoft Entra ID tenant and reviewed the External Collaboration Settings that control guest access.  
This simulates real-world scenarios where organisations onboard external partners while maintaining strict access control.

---

## 🛠 Tools Used  
- Azure Portal  
- Azure CLI (run inside local PowerShell)  
- Microsoft Entra ID (External Identities, Users)  

---

## 🧩 Steps Completed  
This setup simulates secure onboarding of external users into an organisation’s identity system.

### 1. Invited External Guest User  
Sent an invitation to an external email address.

### 2. Reviewed External Collaboration Settings  
Accessed tenant-wide settings controlling who can invite guests and how access is managed.

### 3. Checked Collaboration Restrictions  
Verified guest permissions and domain restrictions.

### 4. Reviewed Guest User Profile  
Confirmed the guest account appears with:
- **User Type = Guest**  
- Username contains **#EXT#**

### 5. Validated via Azure CLI (Local PowerShell)  
Queried guest users using Azure CLI from a local PowerShell terminal.

---

## 🔄 Before & After  

### Before  
- No guest users in the tenant  
- No visibility into collaboration restrictions  
- No validation of external identities  
- No CLI verification  

### After  
- Guest user successfully invited  
- External collaboration settings reviewed  
- Guest access restrictions confirmed  
- CLI validation confirms guest classification  

---

## ✅ Validation  

- Guest appears in Entra ID Users list  
- User Type = **Guest**  
- Username contains **#EXT#**  
- External Collaboration Settings load correctly  
- CLI output returns the guest user  

---

## 🧠 Skills Demonstrated  
- Entra ID identity management  
- External (B2B) collaboration configuration  
- Azure CLI filtering and validation  
- Access governance fundamentals  
- Secure onboarding workflows  

---

## 🛠 Troubleshooting  

### Guest Not Appearing  
Invitation not accepted yet.  
**Fix:** Resend invite or check spam folder.

### CLI Returns No Results  
Logged into incorrect tenant.  
**Fix:** Run:
```powershell
az login
```
and select the correct tenant.

---

## 🔐 Why This Matters  

- **Security:** Controls what external users can access  
- **Governance:** Centralised policy for guest invitations  
- **Operations:** External collaboration is a daily admin task  

Proper guest configuration is critical to maintaining a secure cloud environment.

---

## 🧠 What I Learned  
- How guest identities are created and managed in Entra ID  
- How tenant-wide collaboration settings control access  
- How to validate guest users using Azure CLI  
- Why least-privilege is essential for external identities  

---

## 📸 Screenshots  

```
01-invite-external-user.png  
02-external-collaboration-settings.png  
03-collaboration-restrictions.png  
04-guest-user-profile.png  
05-cli-guest-list.png  
```

---

## 💻 Commands Used  

### List Guest Users
```powershell
az ad user list --filter "userType eq 'Guest'" --output table
```

---

## 📄 Sample Output (Sanitised)

```text
DisplayName      Mail                     UserPrincipalName
---------------  -----------------------  ---------------------------------------------------------
Guest - Mohamed  example@gmail.com        example_gmail.com#EXT#@tenantname.onmicrosoft.com
```

---

## 🎯 Key Takeaway  
Guest access is powerful but must be tightly controlled — secure collaboration starts with proper identity configuration and governance.
