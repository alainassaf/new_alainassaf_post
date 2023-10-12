# Blog Automation with PowerShell

Creating and managing a blog can be a formidable task, demanding substantial time and effort. However, the adoption of **PowerShell** and automation offers a great solution to this challenge.

## Event Details

**Event Type**: Hybrid Event (In-person and Online via Microsoft Teams)

**Date**: September, 20 2023

### Location

- **In-person**: [Insert In-person Venue]
- **Online**: Microsoft Teams

Please see Meeting Attendance Info section below for important details for attending in-person and how to connect if you are attending from home/remote location.

## Meeting Description

Alain will discuss his automation techniques for managing his blog, [**alainassaf.com**](https://alainassaf.com/). He’ll cover the evolution of his process, which includes transitioning from WordPress to local Jekyll development and ultimately incorporating Docker. Alain will share insights into how he utilizes automation to streamline article development and publication, including the use of REST APIs for image acquisition and other automated methods to enhance his content creation and posting workflow.

## Speaker Info

**Speaker**: Alain Assaf

**Bio**: Alain is a highly experienced IT professional with a focus on virtualization platforms and automation tools. He has over 20 years of experience in various IT environments and currently works for the second largest credit union in the United States. Alain holds several certifications, including Citrix and Microsoft, and is actively involved in the Citrix community. You can find his insights and blogs on [**LinkedIn**](https://www.linkedin.com/in/alainassaf/) and [**his website**](https://alainassaf.com/), and he’s also active on Twitter [**@alainassaf**](https://twitter.com/alainassaf). Alain also maintains several repositories on [**GitHub**](https://github.com/alainassaf).

# Files included in this repository
* Create-BlogPost.ps1 - Invokes Plaster and gets an image from Pixabay to generate a blank blog post in my local Jekyll development environment.
* Get-PixabayImage.ps1 - Makes a query using Pixabay's API to download an image (requires a Pixabay API key by creating an account on the site).
* PlasterManifest.xml - Plaster template file that queries the user for info and generates files and folders in my local Jekyll development envrionment to start a draft blog post.
* BlogPost.asp1 - Template file used by Plaster to generate a blank blog post.
