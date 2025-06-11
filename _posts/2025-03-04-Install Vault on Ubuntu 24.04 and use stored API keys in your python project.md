---
layout: post
title: "Install Vault on Ubuntu 24.04 and use stored API keys in your python project"
date: 2025-03-04
---

### What is Vault from HashiCorp?

HashiCorp Vault is a secrets management and encryption platform designed to securely store, manage, and control access to sensitive data, such as passwords, API keys, certificates, and other secrets. It provides a centralized and secure way to manage secrets across an organization, enabling teams to protect their infrastructure, applications, and data.

Key features of HashiCorp Vault include:

* Secrets management: Vault stores and manages secrets, such as passwords, API keys, and certificates, in a secure and encrypted manner.
* Encryption: Vault provides encryption capabilities to protect data at rest and in transit.
* Access control: Vault enables fine-grained access control, allowing administrators to define policies and permissions for accessing secrets.
* Dynamic secrets: Vault can generate dynamic secrets, such as temporary passwords or API keys, that are valid for a limited time.
* Integration: Vault integrates with a wide range of tools and platforms, including cloud providers, container orchestration systems, and configuration management tools.


### Install Vault on Ubuntu 24.04

```bash
sudo snap install vault 
```


### Starting the vault service

 ```sh
sudo snap start vault.vaultd
```

Export your vault address:
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
```

Or you write the address in your *.bashrc* and:
```bash
source .bashrc
```
activate it.

### Initialize the Vault

The Vault needs to be unsealed before it can be used.

**Initialize Vault:**
```bash
vault operator ini
```
This command will output the unseal keys and the initial root token. Make sure to store them securely.

**Unseal Vault**:

Use the unseal keys generated during initialization to unseal Vault. You need to provide at least three unseal keys to unseal Vault.
```sh
vault operator unseal <unseal-key-1>
vault operator unseal <unseal-key-2>
vault operator unseal <unseal-key-3>
```

After providing the required number of unseal keys, Vault should be unsealed and ready for use.

### Save your first API Key in Vault

To store API keys in HashiCorp Vault, you can use the `kv` (Key-Value) secrets engine. Here are the steps to store and retrieve API keys:

**Enable the Key-Value secrets engine** (if not already enabled):

```sh
vault secrets enable -path=secret kv

Success! Enabled the kv secrets engine at: secret/
```

If you *struggle* with *hvac* later and you didn't find the api key, try to disable v1:
```bash
vault secrets disable secret
Success! Disabled the secrets engine (if it existed) at: secret/
```
and activate:
```bash
vault secrets enable -path=secret kv-v2
```

**Store an API key**:

```sh
vault kv put secret/api_key virustotal=YOUR-IP-KEY

=== Secret Path ===
secret/data/api_key

======= Metadata =======
Key                Value
---                -----
created_time       2025-02-25T22:38:14.708521631Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

```

**Retrieve the stored API key**:

```sh
vault kv get secret/api_key
```

Explanation of each command:

- The first command enables the Key-Value secrets engine at the path `secret`.
- The second command stores the API key under the path `secret/api_key` with the key name `my_api_key`.
- The third command retrieves the stored API key from the path `secret/api_key`.

Make sure to replace `your_api_key_value` with your actual API key.

### Python code to fetch you api key

#### Prerequisites

```bash
export VAULT_TOKEN=YOUR-ROOT-TOKEN
```
or export it over *.bashrc*

```bash
pip install hvac
```
I installed *hvac version 2.3.0* with *python version 3.10.16* in a *conda* (Anaconda) environment.

##### Finally an example of usage in python
```python
import hvac  
import os  
  
client = hvac.Client(url='http://127.0.0.1:8200')  
  
vault_token = os.getenv('VAULT_TOKEN')  
# Authenticate with Vault (replace 'your_token' with your actual token)  
client.token = vault_token  
  
read_response = client.secrets.kv.read_secret_version(path='api_key')  

# Extract the API key  
api_key = read_response['data']['data']['virustotal']  
print(f"Retrieved API key: {api_key}")
```

##### Further documentation

https://python-hvac.org/en/stable/overview.html


