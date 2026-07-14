public class SAPOrdersSchedule {

    @AuraEnabled
    public static Id scheduleClass(String jobName, List<String> weekday, String startDate, String endDate, String preferredTime) {
        try {
            if (String.isBlank(jobName)) {
                throw new AuraHandledException('Job Name is required.');
            }

            Date start = Date.valueOf(startDate);
            Date endD  = Date.valueOf(endDate);

            if (endD < start) {
                throw new AuraHandledException('End Date cannot be before Start Date.');
            }

            // preferredTime is expected as "HH:mm" (24-hour). Still works if only an hour is passed.
            Integer hh = 0;
            Integer mm = 0;
            if (String.isNotBlank(preferredTime)) {
                List<String> timeParts = preferredTime.split(':');
                hh = Integer.valueOf(timeParts[0]);
                if (timeParts.size() > 1) {
                    mm = Integer.valueOf(timeParts[1]);
                }
            }

            String monthField = (start.month() == endD.month())
                ? String.valueOf(start.month())
                : start.month() + '-' + endD.month();

            String yearField = (start.year() == endD.year())
                ? String.valueOf(start.year())
                : start.year() + '-' + endD.year();

            String dayOfMonthField;
            String dayOfWeekField;

            if (weekday != null && !weekday.isEmpty()) {
                // Specific weekdays requested -> day-of-week is explicit, day-of-month MUST be '?'
                dayOfMonthField = '?';
                dayOfWeekField = String.join(weekday, ',');
            } else {
                // No weekdays supplied -> fall back to a day-of-month range, day-of-week MUST be '?'
                dayOfMonthField = (start.day() == endD.day())
                    ? String.valueOf(start.day())
                    : start.day() + '-' + endD.day();
                dayOfWeekField = '?';
            }

            String sch = '0 ' + mm + ' ' + hh + ' ' + dayOfMonthField + ' ' + monthField + ' ' + dayOfWeekField + ' ' + yearField;

            System.debug('Generated CRON expression: ' + sch);

            ScheduleBatchClass job = new ScheduleBatchClass();
            Id scheduledJobId = System.schedule(jobName, sch, job);
            return scheduledJobId;

        } catch (Exception e) {
            System.debug('SAPOrdersSchedule.scheduleClass error: ' + e.getMessage());
            throw new AuraHandledException('Unable to schedule job: ' + e.getMessage());
        }
    }
}