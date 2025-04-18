# Moonlight 🌌 userChrome - [Dracula](https://draculatheme.com/) version

A dark userstyle for Firefox inspired by [moonlight-vscode-theme](https://github.com/atomiks/moonlight-vscode-theme) and [github-moonlight](https://github.com/Brettm12345/github-moonlight)

![Firefox screenshot with the moonlight theme activated](https://user-images.githubusercontent.com/1681236/109684344-172c4000-7b78-11eb-88c1-91f9df196c49.png)

It should match other Dracula-themed apps nicely

![Firefox screenshot with the moonlight theme activated and a terminal with Reddit content inside it to the side](https://user-images.githubusercontent.com/1681236/109684797-89048980-7b78-11eb-9820-ad437ccbe1c0.png)



## Installation

1. Open your currently active profile folder
    1. In the URL bar type: `about:profiles`
    2. Look for the profile which has the "Default Profile" property set to true
    3. Click on "Open Folder" button belonging to the "Root Directory" property
2. Create a new folder named chrome
3.  - Clone the theme directly into the chrome folder. If you choose this method you will be able to update the theme by pulling the latest files.  
      OR
    - Download and extract the files in the chrome folder
4. If you're running Firefox 69+
    1. In the URL bar type: `about:config`
    2. You will receive a warning to proceed with caution. Accept the Risk and Continue.
    3. In the "Search preference name" input field type `toolkit.legacyUserProfileCustomizations.stylesheets`
    4. Set it to true by double clicking the false value
5. Restart the browser

## Custom styling

The theme comes **as is** but it can be extended using CSS files provided in the custom folder. Further extensions should be included in the same folder to keep the main theme consistent.
To **enable** custom styles, copy and paste the following `@import` statements at the end of the `userChrome.css` file.

### Re-enable title bar controls (MIN-MAX-CLOSE buttons)

For Windows:

```css
@import "custom/_titlebar-controls-enable-windows.css";
```

For macOS:

```css
@import "custom/_titlebar-controls-enable-macos.css";
```

### Disable megabar behavior

```css
@import "custom/_megabar-disable.css";
```

### Add Developer Tools styling

Set theme to dark in Firefox Developer Tools [settings](https://developer.mozilla.org/en-US/docs/Tools/Settings). Then, add the following line to `userContent.css`:

```
@import "custom/_dev-tools.css";
```

