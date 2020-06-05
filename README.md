: WordPress for iOS #

[![CircleCI](https://circleci.com/gh/wordpress-mobile/WordPress-iOS.svg?style=svg)](https://circleci.com/gh/wordpress-mobile/WordPress-iOS)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

## Build Instructions

Please refer to the sections below for more detailed information. The instructions assume the work is performed from a command line.

1. [Download](https://developer.apple.com/downloads/index.action) and install Xcode. *WordPress for iOS* requires Xcode 11.2.1 or newer.
1. From a command line, `git clone git@github.com:wordpress-mobile/WordPress-iOS.git` in the folder of your preference.
1. `cd WordPress-iOS` to enter the working directory.
1. `rake dependencies` to install all dependencies required to run the project (this may take some time to complete).
1. `rake xcode` to open the project in Xcode.
1. Compile and run the app on a device or an simulator.

In order to login to WordPress.com using the app:

1. Create a WordPress.com account at https://wordpress.com/start/user (if you don't already have one).
1. Create an application at https://developer.wordpress.com/apps/.
1. Set "Redirect URLs"= `https://localhost` and "Type" = `Native` and click "Create" then "Update".
1. Copy the `Client ID` and `Client Secret` from the OAuth Information.
1. From a command line, ensure you are in the project's working directory and run `cp WordPress/Credentials/wpcom_app_credentials-example .configure-files/wpcom_app_credentials` to copy the sample credentials file.
1. Open the newly copied `.configure-files/wpcom_app_credentials` with the text editor of your choice, and replace `WPCOM_APP_ID` and `WPCOM_APP_SECRET` with the `Client ID` and `Client Secret` of the application you created. Note that `.configure-files` will be hidden by default in Finder. If you need to view it in Finder, hold down `Control`+`Shift`+`.` and it should appear.
1. Recompile and run the app on a device or an simulator.

You can only log in with the WordPress.com account that you used to create the WordPress application.

### Third party tools

We use a few tools to help with development. Running `rake dependencies` will configure them for you.

#### CocoaPods

WordPress for iOS uses [CocoaPods](http://cocoapods.org/) to manage third party libraries.
Third party libraries and resources managed by CocoaPods will be installed by the `rake dependencies` command above.

#### SwiftLint

We use [SwiftLint](https://github.com/realm/SwiftLint) to enforce a common style for Swift code. The app should build and work without it, but if you plan to write code, you are encouraged to install it. No commit should have lint warnings or errors.

You can set up a Git [pre-commit hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to run SwiftLint automatically when committing by running:

`rake git:install_hooks`

This is the recommended way to include SwiftLint in your workflow, as it catches lint issues locally before your code makes its way to Github.

Alternately, a SwiftLint scheme is exposed within the project; Xcode will show a warning if you don't have SwiftLint installed.

Finally, you can also run SwiftLint manually from the command line with:

`rake lint`

If your code has any style violations, you can try to automatically correct them by running:

`rake lint:autocorrect`

Otherwise you have to fix them manually.

### Open Xcode

Launch the workspace by running the following from the command line:

`rake xcode`

This will ensure any dependencies are ready before launching Xcode.

You can also open the project by double clicking on `WordPress.xcworkspace` file, or launching Xcode and choose `File` > `Open` and browse to `WordPress.xcworkspace`.

### Setup Credentials

In order to login to WordPress.com with the app you need to create an account over at the [WordPress.com Developer Portal](https://developer.wordpress.com).

After you create an account you can create an application on the [WordPress.com applications manager](https://developer.wordpress.com/apps/).

When creating your application, select "Native client" for the application type. The applications manager currently requires a "redirect URL", but this isn't used for mobile apps. Just use "https://localhost".

Your new application will have an associated client ID and a client secret key. These are used to authenticate the API calls made by your application.

Next, create a credential file. Start by copying the sample credentials file in your local repo by doing this:

`cp WordPress/Credentials/wpcom_app_credentials-example .configure-files/wpcom_app_credentials`

Then edit the `WordPress/Credentials/wpcom_app_credentials-example` file and change the `WPCOM_APP_ID` and `WPCOM_APP_SECRET` fields to the values of your application's client ID and client secret.

Now you can compile and run the app on a simulator and log in with a WordPress.com account.  Note that authenticating to WordPress.com via Google is not supported in development builds of the app, only in the official release.

**Remember the only WordPress.com account you will be able to login in with is the one used to create your client ID and client secret.**

Read more about [OAuth2](https://developer.wordpress.com/docs/oauth2/) and the [WordPress.com REST endpoint](https://developer.wordpress.com/docs/api/).

## Contributing

Read our [Contributing Guide](CONTRIBUTING.md) to learn about reporting issues, contributing code, and more ways to contribute.

## Security

If you happen to find a security vulnerability, we would appreciate you letting us know at https://hackerone.com/automattic and allowing us to respond before disclosing the issue publicly.

## Getting in Touch ##

If you have questions about getting setup or just want to say hi, join the [WordPress Slack](https://chat.wordpress.org) and drop a message on the `#mobile` channel.

## Resources

- The [docs](docs/) contain information about our development practices.
- [WordPress Mobile Blog](http://make.wordpress.org/mobile)
- [WordPress Mobile Handbook](http://make.wordpress.org/mobile/handbook/)

## License

WordPress for iOS is an Open Source project covered by the [GNU General Public License version 2](LICENSE).
