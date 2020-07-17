//
//  publicUserDataGET.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 14/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable{
    let lastName: String
    let socialAccounts: [String]
    let mailingAddress: String
    let cohortKeys: [String]
    let signature, stripeCustomerID: String
    let userGuard: Guard
    let facebookID, timezone, sitePreferences, occupation: String
    let image: String
    let firstName: String
    let jabberID, languages: String
    let badges: [String]
    let location, externalServicePassword: String
    let principals: [String]
    let enrollments: [String]
    let email: Email
    let websiteURL: String
    let externalAccounts: [String]
    let bio, coachingData: String
    let tags, affiliateProfiles: [String]
    let hasPassword: Bool
    let emailPreferences: EmailPreferences
    let resume: String
    let key, nickname: String
    let employerSharing: Bool
    let memberships: [Membership]
    let zendeskID: String
    let registered: Bool
    let linkedinURL, googleID: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature = "_signature"
        case stripeCustomerID = "_stripe_customer_id"
        case userGuard = "guard"
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
    let verificationCodeSent, verified: Bool
    let address: String

    enum CodingKeys: String, CodingKey {
        case verificationCodeSent = "_verification_code_sent"
        case verified = "_verified"
        case address
    }
}

// MARK: - EmailPreferences
struct EmailPreferences: Codable {
    let okUserResearch, masterOk, okCourse: Bool

    enum CodingKeys: String, CodingKey {
        case okUserResearch = "ok_user_research"
        case masterOk = "master_ok"
        case okCourse = "ok_course"
    }
}

// MARK: - Membership
struct Membership: Codable {
    let current: Bool
    let groupRef: Ref
    let creationTime, expirationTime: String

    enum CodingKeys: String, CodingKey {
        case current
        case groupRef = "group_ref"
        case creationTime = "creation_time"
        case expirationTime = "expiration_time"
    }
}

// MARK: - Ref
struct Ref: Codable {
    let ref: SubjectKind
    let key: String
}

enum SubjectKind: String, Codable {
    case account = "Account"
    case scopedRole = "ScopedRole"
}

// MARK: - Guard
struct Guard: Codable {
    let canEdit: Bool
    let permissions: [Permission]
    let allowedBehaviors: [String]
    let subjectKind: SubjectKind

    enum CodingKeys: String, CodingKey {
        case canEdit = "can_edit"
        case permissions
        case allowedBehaviors = "allowed_behaviors"
        case subjectKind = "subject_kind"
    }
}

// MARK: - Permission
struct Permission: Codable {
    let derivation: [Derivation]
    let behavior: String
    let principalRef: Ref

    enum CodingKeys: String, CodingKey {
        case derivation, behavior
        case principalRef = "principal_ref"
    }
}

enum Derivation: String, Codable{
    case synthetic = "synthetic"
}
