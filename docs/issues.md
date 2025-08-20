Known issues: 

1. In case of successful temptation destruction, `Streak` should only be updated if today's `Streak` isn't already recorded.
2. In case of relapse, just UPSERT today's `Streak` to zero count.
3. 
    - User HAS to select an activity before going to timer page. Timer should ONLY start once the next button is pressed. Disable next button until activity is selected. Add a text field so that user can add their activities. Maintain state between pages. Pages should check for already existing state if any. Temptation flow should load data from the `currentActiveTemptation` provider. Wait, then we don't really need local vars for selectedActivity. We can just use the provider itself.

    - Use everything from provider, even for storing temp state in shared_prefs. Don't call the storage directly. Simplify things by just using the provider. That's it.
4. Test that:
    - On `success`, it should increment the count of streak IF there is no record for today. 
    - On `failure` it should UPSERT **only the count** of today's `Streak` to zero.

THEN => Temptation FINISH | Inshaa Allah!