# Duke Asset Management iOS Mobile App 


Jiaoyang Chen, Hugo Hu, Minghui Zhu


<img src="images/logo.png" width="100" height="100">


## Table of Contents


## 1. Introduction

### Overview

The Duke Asset Management iOS Mobile App serves as a mobile gateway to MediaBeacon, Duke's extensive digital asset management system. This application enables users to seamlessly view, download, and upload files while ensuring that all modifications are synchronized with the MediaBeacon web server. Designed for convenience and efficiency, this mobile interface is a significant step forward in digital asset management.

### Problems

MediaBeacon, as the cornerstone of Duke's digital storage, houses over 4 million digital assets, including images, PDFs, videos, and more. Despite its vast capacity and robust web server, MediaBeacon's lack of a mobile application has been a notable shortfall. Users at Duke have frequently reported that this gap in mobile accessibility significantly hampers their work efficiency. The absence of a mobile interface limits the usability and accessibility of the system, particularly for users who rely on mobile devices for their work.

### Solution Impacts
In response to these issues, we have developed a tailored iOS app for MediaBeacon. This solution brings two major impacts:

1. **Economic Saving**: By integrating with the existing MediaBeacon system, our app negates the need for additional software subscriptions. This approach results in substantial cost savings for Duke, optimizing their budget allocation.

2. **Workflow Improvement**: The app is designed to streamline the workflow process. By providing mobile access to MediaBeacon's vast repository, it enhances user productivity and accessibility. This improvement in workflow not only makes the process more efficient but also more adaptable to the modern needs of mobile-centric users.

## 2. Project Structure

![Project Structure](images/project-structure.png)


## Function List / Feature Demo

### 1. Login

- Initiate a redirect to the Duke OAuth authentication page.
- Upon successful authentication, securely store the **AuthToken** within the iOS **UserDefaults** system.
- Note that the AuthToken remains valid for a period of **7 days**.
- After authentication and token storage, navigate to the main folder page.

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="2" style="text-align:center;">Login Page</th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/login-0.png" style="width:300px; height:auto;" /></td>
    <td><img src="images/login-1.png" style="width:300px; height:auto;" /></td>
  </tr>
</table>



### 2. Browse Folder​

- Switch between **Icon** or **List** view using the toggle on the top-right menu bar.
- Organize files by **Name**, **Date**, or **Type**, with options for both ascending and descending order.
- Ensure all operations load **asynchronously**, with a **Retry Mechanism** for enhanced reliability.

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="2" style="text-align:center;">Browse Folder </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/folder-0.png" style="width:300px; height:auto;" /></td>
    <td><img src="images/folder-1.png" style="width:300px; height:auto;" /></td>
  </tr>
    <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/folder-2.png" style="width:300px; height:auto;" /></td>
    <td><img src="images/folder-3.png" style="width:300px; height:auto;" /></td>
  </tr>
</table>



### 3. File Operations​

APIs are implemented for:
1. Create a new folder
2. Rename a folder or file
3. Upload photos from local
4. Delete a folder or file
    - Warning: Deleting Folder
    - Error: If not exists now

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="2" style="text-align:center;">File Operations </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/rename-folder-0.png" style="width:300px; height:auto;" /></td>
    <td><img src="images/rename-folder-1.png" style="width:300px; height:auto;" /></td>
  </tr>
    <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/upload-files-0.png" style="width:300px; height:auto;" /></td>

  </tr>
</table>

GIFS

### 4. ACL

### 5. Search

- Search xxxx.
- The search functionality within the app is designed with dual scope for user convenience:
    - **Overall**: Allows users to search across all available content.
    - **Current Folder**: Searches are limited to the folder currently being viewed, with the folder's path included in the URL for precise results.

- The **number of matches** is displayed on the top right.

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="2" style="text-align:center;">Search </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/search-0.png" style="width:300px; height:auto;" /></td>
    <td><img src="images/search-1.png" style="width:300px; height:auto;" /></td>
  </tr>
</table>

### 6. Advance Search
- Allow users to add restrictions on dates, folder names and file names, and allows special logical conditions.
- This example is to list all the files in the folder “Sample” and its sub-folders.

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="2" style="text-align:center;">Advance Search </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/adv-search-0.png" style="width:300px; height:auto;" /></td>
    <td><img src="images/adv-search-1.png" style="width:300px; height:auto;" /></td>
  </tr>
</table>

### 7. File Details

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="1" style="text-align:center;">File Details </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/file-details.png" style="width:620px; height:auto;" /></td>
  </tr>
</table>

### 8. File Preview


<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="1" style="text-align:center;">File Preview </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/file-preview.png" style="width:620px; height:auto;" /></td>
  </tr>
</table>

### 9. Themes & Modes

Themes:

- Default Theme
- Christmas Theme
- New Year Theme
- Duke Theme

Appearance:
- Light Mode
- Dark Mode
- System Setting

<table>
  <tr>
    <!-- Header spanning across two columns -->
    <th colspan="1" style="text-align:center;">Themes & Modes </th>
  </tr>
  <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/theme-0.png" style="width:620px; height:auto;" /></td>
  </tr>
    <tr style="text-align:center;">
    <!-- Images in individual cells, centered -->
    <td><img src="images/theme-1.png" style="width:620px; height:auto;" /></td>
  </tr>
</table>





## Running Environment

## How to Run 


## 1. Project Management (Notion)

- Sprint 1:
- Sprint 2:
- Sprint 3:



## Acknowledge

### Library Reference

This project utilizes several open-source libraries:

- `Alamofire v5.8.1` - for efficient HTTP networking, supporting resuming interrupted transmissions and handling large file uploads.
- `DirectoryBrowser v0.1.0` - for displaying files in a list view within the app.
- `FilePreviews v0.2.0` - for generating file previews and thumbnails, leveraging native iOS features.
- `PopupView v2.8.3` - for customizable floating dialog animations.
- `Swift-log v1.5.3` - for logging, particularly in concurrent environments.
- `SwiftUI Text Animation Library v0.1.0` - for adding text animations within SwiftUI.
- `WCLShineButton v1.0.8` - for sophisticated button animations in UIKit.
- `Zip v2.1.2` - for compressing and decompressing files locally using Swift.

These libraries have significantly contributed to the functionality of this app.

### Sponsor..


## Test