//
//  publicUserDataGET.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 14/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

struct User: Codable {
    let lastName: String?
    let socialAccounts: [String?]
    let mailingAddress: String?
    let cohortKeys: [String?]
    let signature, stripeCustomerID: String?
    let welcomeGuard: Guard?
    let facebookID, timezone, sitePreferences, occupation: String?
    let image: String?
    let firstName: String?
    let jabberID, languages: String?
    let badges: [String?]
    let location, externalServicePassword: String?
    let principals, enrollments: [String?]
    let email: Email
    let websiteURL: String?
    let externalAccounts: [String?]
    let bio, coachingData: String?
    let tags, affiliateProfiles: [String?]
    let hasPassword: Bool?
    let emailPreferences, resume: String?
    let key, nickname: String?
    let employerSharing: Bool?
    let memberships: [String?]
    let zendeskID: String?
    let registered: Bool?
    let linkedinURL, googleID: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature
        case stripeCustomerID = "_stripe_customer_id"
        case welcomeGuard = "guard"
        case facebookID = "_facebook_id"
        case timezone
        case sitePreferences = "site_preferences"
        case occupation
        case image = "_image"
        case firstName = "first_name"
        case jabberID = "jabber_id"
        case languages
        case badges = "_badges"
        case location
        case externalServicePassword = "external_service_password"
        case principals = "_principals"
        case enrollments = "_enrollments"
        case email
        case websiteURL = "website_url"
        case externalAccounts = "external_accounts"
        case bio
        case coachingData = "coaching_data"
        case tags
        case affiliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case key, nickname
        case employerSharing = "employer_sharing"
        case memberships = "_memberships"
        case zendeskID = "zendesk_id"
        case registered = "_registered"
        case linkedinURL = "linkedin_url"
        case googleID = "_google_id"
        case imageURL = "_image_url"
    }
}

// MARK: - Email
struct Email: Codable {
    let address: String?
    let verified, verificationCodeSent: Bool?

    enum CodingKeys: String, CodingKey {
        case address
        case verified = "_verified"
        case verificationCodeSent = "_verification_code_sent"
    }
}

// MARK: - Guard
struct Guard: Codable {
}
