# Applied to every app that uses this plugin, so release builds can keep
# minifyEnabled / shrinkResources on.

# PAX NeptuneLiteApi: the keep rules PAX ships with the SDK
# (NeptuneProguardRules.pro in the NeptuneLiteApi V4.26.00 package).
-keep class com.pax.dal.** {
    <fields>;
    <methods>;
}

-keep class com.pax.nep.** {
    <fields>;
    <methods>;
}

-keep class com.pax.neptunelite.** {
    <fields>;
    <methods>;
}
