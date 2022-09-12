# Dropbox Configuration for BadUSB 

This tutorial will explain how to create a BadUSB payload that will run a remote script stored on the Web, which is capable of uploading files to a remote location. Both the _download_ of the script and the _file upload_ parts will use Dropbox. 

**NOTE**: be aware that if your payloads/scripts are compromised, it might be possible to identify the original Dropbox account. So we recommend using an anonymous or disposable Dropbox account to operate everything.

## Create a Dropbox Application

First we will create a personal Dropbox application that will have permissions onlly to _upload_ files to a _specific folder_.

The stricter permission settings is recommended, because it will limit the access in case of the keys/tokens/secrets are, somehow, compromised/leaked. For instance, if the key had access to _read_ and to _any_ folder of the account, one could download all the files in the Dropbox account that you will be using.

To create an application like that, do the following:
 1. Go to the [Dropbox New App Creation](https://www.dropbox.com/developers/apps/create/) page. Fill the information as following:
  1. API: Scoped access
  2. Access Type: App folder (
  3. Name: <any> (it should be exclusive)
 2. Go to the [My apps](https://www.dropbox.com/developers/apps/) page and enter in your recently created application page.
 3. Go to the "Permissions" tab of your app.
 4. Mark these two permissions:
    - `files.metadata.write`
    - `files.content.write`
 5. Click on the "Submit" button to update the app's permissions.

## Setup the Key of the Dropbox Application

 1. Go to the [My apps](https://www.dropbox.com/developers/apps/) page and enter in your recently created application page.
 2. Go to the "Settings" tab of your app.
 3. Copy and write down your `App key` and `App secret`.
 4. Open a web browser and log into your Dropbox account (if it is not already).
 5. Create an URL with your `App key` and open it in your browser:
```
https://www.dropbox.com/oauth2/authorize?client_id=<APP_KEY>&token_access_type=offline&response_type=code
```
 6. Click on `Continue` to indicate that you are aware that you are connecting to a development application.
 7. Click on `Allow` to allow that the application have the mentioned permissions.
 8. Copy and write down the `Authorization code` shown in the box.
 9. Make a HTTP request to retrieve a refresh token: 
```
curl https://api.dropbox.com/oauth2/token \
    -d code=<AUTHORIZATION_CODE> \
    -d grant_type=authorization_code \     
    -u <APP_KEY>:<APP_SECRET>
```
 10. Copy and write down write down the `Refresh token` from the `"refresh_token"` key of the JSON response.

## Reference
 - https://www.dropbox.com/developers/documentation/http/documentation
 - https://developers.dropbox.com/oauth-guide

