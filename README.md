# Track2Grow

A Salesforce-native analytics package that tracks how long records spend in each picklist stage, using field history tracking and Business Hours calculations.

## Package Functionality

- **Time-in-Stage Tracking**: Monitors any configured picklist field on a target object and calculates how long each record spends in each stage value.
- **Business Hours-Aware Calculations**: Duration calculations respect your org's configured Business Hours (rather than raw wall-clock time), so time spent outside working hours isn't counted against stage duration. Resolved dynamically from the org's active Business Hours record at runtime.
- **Field History-Driven**: Relies on Salesforce Field History Tracking to detect stage transitions.
- **Batch Calculation Pipeline**: Includes a scheduled/batch Apex process that periodically processes historical stage-change data and rolls it up into reportable time-in-stage metrics.
- **Lightning Web Components**: Provides LWC-based visualizations of time-in-stage data for use on Lightning record pages.

## Prerequisites

- **Field History Tracking** must be enabled on any object(s) you intend to track stage-duration for.
- **Business Hours** must be configured in your org (Setup > Business Hours).
- **API Access**: the installing user must have "Modify All Data" or equivalent admin permissions during installation.
- **Salesforce Edition**: Enterprise Edition or higher.
- **Existing Automation Review**: review for potential conflicts with this package's stage-tracking logic before installing in production.

## Installation

1. Install the package using the provided installation URL.
2. Choose **Admins Only** for install permissions unless broader access is needed at install time.
3. Wait for install confirmation before proceeding to post-install configuration.

## Post-Deployment Steps

1. **Grant Object & Field Access**: This package does not currently ship a Permission Set. Grant access via Profile-level Object/Field-Level Security.
2. **Configure Field History Tracking** if not already enabled.
3. **Verify Business Hours Resolution** in the org.
4. **Update the Business Hours Custom Label** to point to the correct Business Hours record for this org.
5. **Schedule the Batch Job** via Setup > Apex Classes > Schedule Apex.
6. **Add Components to Page Layouts** via App Builder.
7. **Validate with Sample Data** before rolling out to end users.

## Field-Level Security (FLS)

- All custom fields default to **hidden** for all profiles except System Administrator.
- No Permission Set currently ships with this package — grant FLS directly via Profile.
- Reporting requires **Read** FLS at minimum.
- `WITH SECURITY_ENFORCED` or `Security.stripInaccessible` may cause partial/blank data for users without correct FLS.

## Support

For issues, questions, or feature requests, contact Growth Natives at [support contact].
