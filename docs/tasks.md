1. Latest date streak count is the algorithm ✅
2. The modal is messed up: use ListView or SingleChildScrollView ✅
3. Chips look super bad, their outlines ajeeb. They should be light grey ✅
4. Capital Letters look super bad ✅
5. Text not in center of buttons, buttons are neomorphic, why not create our own button just like the emergency button? ✅
5. Submit might not be nice word. Use "Save" instead! ✅
6. Undoing relapse should be very simple. We delete today's streak object. Streak model should have a relapse flag to whether it was relapse or not. Or maybe just a success flag could be enough. True would mean success and false would mean relapse. ✅

---

1. Quick stats ✅

---

1. Create UserProfile, store onboarding information inside UserProfile ✅
2. Store goal information inside UserProfile ✅
3. Create goal provider ✅
4. Whenever creating Streak object in database, the goal will always come from goal provider, inShaaAllah ✅
5. Quick stats can listen to goal provider ✅

---

1. Create the profile screen ✅
2. User should also be able to upload their avatar / picture ✅

---

1. Make onboarding screen final; correct small and large details, remove bekaar stuff, fix bug where goals and other things are not being persisted in db. Could it be that the onboarding flow is not returning the objects?

2. Make profile screen final; beautify it. It looks horrible.

3. ImageService should be a RiverPod provider. An AsyncNotifier class.

4. Password encryption: 
    - Encryption Service
    - Password Screen that should be shown at start (bind with the success screen `MainAppScreen`)
5. Use a stack for maintaining the state of the pages in the onboarding flow

---

1. Design the emergency screen with full dedication and love 
2. Ask the user thoughtful questions 
3. Remind the user of Allah, punishment and Jannah, and what would happen if they relapse vs. if they stay firm
4. Remind them that Allah does not burden a soul more than it can bear
5. Show them breathing exercises, etc. 

---

1. Show history of streaks
2. Show history of relapses 
3. Show history of prayers!

---

1. Show prayer times
    - Incorporate the aladhaan API
    - Add notifications for each prayer
2. Add reminder notifs for recording streak

---

1. A beautiful component for showing daily Du'a
2. A beautiful screen for showing Du'as, daily Adkhaar, etc.

---

1. Fix all overflow issues
2. Fix bugs
3. Why `null` immediately when the on-boarding completes?
4. All components should blend well in dark mode 
5. Create db for media (posts, videos, etc.) in Supabase
6. Create realistic and sensible challenges
7. `SizedBox(es)` should be consistent