--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-4.pgdg110+1)
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    value character varying(4000),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO keycloak;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO keycloak;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO keycloak;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO keycloak;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO keycloak;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO keycloak;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO keycloak;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
3f967bc7-f45d-455e-b6b6-fb676ead4fe6	\N	auth-cookie	master	e831f332-635d-42fb-a7ee-6b14c6763a73	2	10	f	\N	\N
cee04543-fe50-4141-840c-a366c8d756ff	\N	auth-spnego	master	e831f332-635d-42fb-a7ee-6b14c6763a73	3	20	f	\N	\N
46629bdd-b5ac-496e-8a35-a98a5f7f1dac	\N	identity-provider-redirector	master	e831f332-635d-42fb-a7ee-6b14c6763a73	2	25	f	\N	\N
7724ccb0-8c43-40e4-b50e-2886b86391b9	\N	\N	master	e831f332-635d-42fb-a7ee-6b14c6763a73	2	30	t	c13a46ce-3026-44e4-8968-c5b40c094378	\N
86c243bd-6de8-4f4f-b8a0-c068ebe7cb2e	\N	auth-username-password-form	master	c13a46ce-3026-44e4-8968-c5b40c094378	0	10	f	\N	\N
112ad340-adb5-420c-a532-a273f677e295	\N	\N	master	c13a46ce-3026-44e4-8968-c5b40c094378	1	20	t	c744c75b-752e-46b3-a4d1-0f0bd40df319	\N
7e37b8c9-4a4c-4492-ad34-3e2515669a14	\N	conditional-user-configured	master	c744c75b-752e-46b3-a4d1-0f0bd40df319	0	10	f	\N	\N
b316ddf5-5295-4727-be25-e7bf56c1627c	\N	auth-otp-form	master	c744c75b-752e-46b3-a4d1-0f0bd40df319	0	20	f	\N	\N
3ffefa0d-dacb-40c1-b522-1cca35e3ae5c	\N	direct-grant-validate-username	master	b0ddfd06-db22-4454-9f73-4f7eee64188f	0	10	f	\N	\N
23f1f748-6e6e-4b8e-a48d-c2c2e57954c4	\N	direct-grant-validate-password	master	b0ddfd06-db22-4454-9f73-4f7eee64188f	0	20	f	\N	\N
5680edde-7f21-4951-8b08-60b608a7fd08	\N	\N	master	b0ddfd06-db22-4454-9f73-4f7eee64188f	1	30	t	c957fab9-39a9-489c-b2a6-212a883220ed	\N
529d768b-1d1c-4830-9660-702a173d2675	\N	conditional-user-configured	master	c957fab9-39a9-489c-b2a6-212a883220ed	0	10	f	\N	\N
418aa123-9912-4506-8905-3addced3a3ee	\N	direct-grant-validate-otp	master	c957fab9-39a9-489c-b2a6-212a883220ed	0	20	f	\N	\N
17ecc80b-8e7d-410f-a62e-72ea2a009772	\N	registration-page-form	master	125c4be6-5a99-4994-b8ab-5bfc741306b1	0	10	t	f9e0b120-94dd-46f4-8ce1-c4b6711c18cd	\N
73a8e690-0fcc-4c3b-807b-6d5aa1adaaff	\N	registration-user-creation	master	f9e0b120-94dd-46f4-8ce1-c4b6711c18cd	0	20	f	\N	\N
e598d848-442f-456e-b306-1953ee9aa6a9	\N	registration-profile-action	master	f9e0b120-94dd-46f4-8ce1-c4b6711c18cd	0	40	f	\N	\N
f03f324a-e8e1-4f0d-b4cc-dff7bb75326b	\N	registration-password-action	master	f9e0b120-94dd-46f4-8ce1-c4b6711c18cd	0	50	f	\N	\N
ef235b83-adf5-49c0-9a20-c4a8155646a3	\N	registration-recaptcha-action	master	f9e0b120-94dd-46f4-8ce1-c4b6711c18cd	3	60	f	\N	\N
a2fb290f-a039-4081-bb19-1a2966f4ab9a	\N	reset-credentials-choose-user	master	4ad9d0bf-5539-406c-9e20-432aa4369b49	0	10	f	\N	\N
9d82198a-9a81-4da3-8f0c-a8010bb12d16	\N	reset-credential-email	master	4ad9d0bf-5539-406c-9e20-432aa4369b49	0	20	f	\N	\N
f0df9078-1e75-4768-acef-7f527060d458	\N	reset-password	master	4ad9d0bf-5539-406c-9e20-432aa4369b49	0	30	f	\N	\N
6a8dbc79-8c13-40fe-91dc-980d09b9ad73	\N	\N	master	4ad9d0bf-5539-406c-9e20-432aa4369b49	1	40	t	6c90c3d3-987e-4995-878f-a1b0d877b5ec	\N
fd61f206-99ea-44cd-ad13-71a418b490a2	\N	conditional-user-configured	master	6c90c3d3-987e-4995-878f-a1b0d877b5ec	0	10	f	\N	\N
e9225750-8e96-4e7a-a916-ce9d8b988f9c	\N	reset-otp	master	6c90c3d3-987e-4995-878f-a1b0d877b5ec	0	20	f	\N	\N
004af47f-5a58-420f-860e-bb9380fba3ce	\N	client-secret	master	dc44410b-87e3-4c00-9f4a-649200dcf570	2	10	f	\N	\N
9e918f47-5023-49db-b75d-1e62f0768d26	\N	client-jwt	master	dc44410b-87e3-4c00-9f4a-649200dcf570	2	20	f	\N	\N
b7d479cf-ea32-41eb-8964-e4cd55a247cd	\N	client-secret-jwt	master	dc44410b-87e3-4c00-9f4a-649200dcf570	2	30	f	\N	\N
e70a46f1-6c7a-423b-a9ec-6af9e58a1bff	\N	client-x509	master	dc44410b-87e3-4c00-9f4a-649200dcf570	2	40	f	\N	\N
a9ae9aeb-e14e-4be1-a43c-0a3a2469b610	\N	idp-review-profile	master	c38c4d8d-14f4-4bfa-8114-d29fe79fb0fc	0	10	f	\N	97d585f6-4d1e-47f6-92b7-be27bd2e3f02
10eff39b-2046-4a66-aadd-49af0041fe24	\N	\N	master	c38c4d8d-14f4-4bfa-8114-d29fe79fb0fc	0	20	t	6b70b79a-58df-43c9-b327-319f380bce91	\N
b668e93d-30b5-4b31-aefb-9c702387335a	\N	idp-create-user-if-unique	master	6b70b79a-58df-43c9-b327-319f380bce91	2	10	f	\N	36900f37-0f82-483b-a033-58f74ddc86f3
07e3ec19-514e-4765-a15d-758953f4967c	\N	\N	master	6b70b79a-58df-43c9-b327-319f380bce91	2	20	t	42bca9f2-5ebf-4890-a44b-00c41d3e67ce	\N
4d6acc39-f490-433c-9c74-6e793204f790	\N	idp-confirm-link	master	42bca9f2-5ebf-4890-a44b-00c41d3e67ce	0	10	f	\N	\N
4e85ad51-7916-443d-b395-3da912e0234f	\N	\N	master	42bca9f2-5ebf-4890-a44b-00c41d3e67ce	0	20	t	83334db3-8288-46ed-8eef-61b7f1e03c16	\N
61e6f935-021c-411c-8d28-c69b5442e731	\N	idp-email-verification	master	83334db3-8288-46ed-8eef-61b7f1e03c16	2	10	f	\N	\N
094d6fb6-4eb3-417c-8b86-1054db80ccdf	\N	\N	master	83334db3-8288-46ed-8eef-61b7f1e03c16	2	20	t	470182c3-1622-4666-8b7b-53a7ea0a338d	\N
a5ab6e58-f4c8-48f4-958e-33eefa932a0d	\N	idp-username-password-form	master	470182c3-1622-4666-8b7b-53a7ea0a338d	0	10	f	\N	\N
4e494855-d20e-4c35-a5c5-9e8616775e56	\N	\N	master	470182c3-1622-4666-8b7b-53a7ea0a338d	1	20	t	01bd8464-370e-4550-b696-da327391cd59	\N
db259cbb-ab19-4c67-be35-87c38c0d9993	\N	conditional-user-configured	master	01bd8464-370e-4550-b696-da327391cd59	0	10	f	\N	\N
d3bb8618-655b-4a03-8910-e9fa46d17628	\N	auth-otp-form	master	01bd8464-370e-4550-b696-da327391cd59	0	20	f	\N	\N
907b327a-5658-47e1-8b35-4bdf07ed434e	\N	http-basic-authenticator	master	956c3f4a-01de-416c-bbbc-e25783ca6cd1	0	10	f	\N	\N
ed0c2c74-2937-4816-b18d-51395909d4b9	\N	docker-http-basic-authenticator	master	be78d0d6-9571-4cf6-b9f9-9c4410acfb41	0	10	f	\N	\N
2b95044f-91e7-4d46-a33e-69eb995308ee	\N	no-cookie-redirect	master	6233233d-5482-4cd8-9732-b29482ba8f1a	0	10	f	\N	\N
ef553748-1c23-44e5-a3a8-4b4133c7e6ec	\N	\N	master	6233233d-5482-4cd8-9732-b29482ba8f1a	0	20	t	7ba422e4-b527-40aa-979f-f5be5b5c1686	\N
19db4f02-2e52-4d1f-8655-3fbddd4b5373	\N	basic-auth	master	7ba422e4-b527-40aa-979f-f5be5b5c1686	0	10	f	\N	\N
05b506b6-afda-4554-b3ec-7ae2b5ccb3e1	\N	basic-auth-otp	master	7ba422e4-b527-40aa-979f-f5be5b5c1686	3	20	f	\N	\N
2dfbf32b-ee88-4abd-bee5-4f2518ce26cf	\N	auth-spnego	master	7ba422e4-b527-40aa-979f-f5be5b5c1686	3	30	f	\N	\N
887c0326-87bd-4560-9f88-30e5f3378794	\N	auth-cookie	MedLabMS	2237847d-6238-4ddb-aad4-d17914cdbf54	2	10	f	\N	\N
54e54043-bf77-4bb7-8c4b-e6fdc4cf1111	\N	auth-spnego	MedLabMS	2237847d-6238-4ddb-aad4-d17914cdbf54	3	20	f	\N	\N
c4ce8a59-fe60-4479-81ba-d3a8dd8c34c3	\N	identity-provider-redirector	MedLabMS	2237847d-6238-4ddb-aad4-d17914cdbf54	2	25	f	\N	\N
4c5c183c-5ff1-410f-8db3-6f0e8ca14d56	\N	\N	MedLabMS	2237847d-6238-4ddb-aad4-d17914cdbf54	2	30	t	5a7cca38-f150-4c44-8343-bef2d2a39306	\N
38dd8ffe-8924-41f0-ab85-47bf1a26d44d	\N	auth-username-password-form	MedLabMS	5a7cca38-f150-4c44-8343-bef2d2a39306	0	10	f	\N	\N
0b8d3b0a-fa80-48e2-b69e-fb0895fa3cb9	\N	\N	MedLabMS	5a7cca38-f150-4c44-8343-bef2d2a39306	1	20	t	d1f6b2e1-bf8e-4c14-b827-94293a41e73a	\N
422829e2-7b3c-41b7-b52e-304042c51a99	\N	conditional-user-configured	MedLabMS	d1f6b2e1-bf8e-4c14-b827-94293a41e73a	0	10	f	\N	\N
376f37ce-9c4a-423b-a00f-123420fddf08	\N	auth-otp-form	MedLabMS	d1f6b2e1-bf8e-4c14-b827-94293a41e73a	0	20	f	\N	\N
69201cce-70e4-4593-888d-6fc406f53367	\N	direct-grant-validate-username	MedLabMS	2f45d891-25d4-44cf-8787-582d54a64c9c	0	10	f	\N	\N
34123d1e-ac4a-48d6-9cfc-92c1ae875e32	\N	direct-grant-validate-password	MedLabMS	2f45d891-25d4-44cf-8787-582d54a64c9c	0	20	f	\N	\N
649b048e-14ab-4966-8149-d759c11e4371	\N	\N	MedLabMS	2f45d891-25d4-44cf-8787-582d54a64c9c	1	30	t	36864c68-262c-492d-94b2-3b1f1d96eecc	\N
3d33e546-ffa2-4e0c-80d6-4990150b3401	\N	conditional-user-configured	MedLabMS	36864c68-262c-492d-94b2-3b1f1d96eecc	0	10	f	\N	\N
c004ae69-4fc4-4e97-b553-2cb715928fbc	\N	direct-grant-validate-otp	MedLabMS	36864c68-262c-492d-94b2-3b1f1d96eecc	0	20	f	\N	\N
71440202-3322-4c0b-888e-0f50842691f5	\N	registration-page-form	MedLabMS	daddec87-b2be-4de0-a5cd-8a8ae26a195c	0	10	t	f66a450b-c449-4a9a-b603-159da5147a45	\N
3242b086-a571-4a94-8748-2f34d4af03ca	\N	registration-user-creation	MedLabMS	f66a450b-c449-4a9a-b603-159da5147a45	0	20	f	\N	\N
467aaa6b-b6ba-4715-81f5-aa6298671ec6	\N	registration-profile-action	MedLabMS	f66a450b-c449-4a9a-b603-159da5147a45	0	40	f	\N	\N
86584825-c990-4e53-aaba-e51d1bd919f9	\N	registration-password-action	MedLabMS	f66a450b-c449-4a9a-b603-159da5147a45	0	50	f	\N	\N
539d34ec-2cd1-49fd-9bb2-490c1a2ca368	\N	registration-recaptcha-action	MedLabMS	f66a450b-c449-4a9a-b603-159da5147a45	3	60	f	\N	\N
a8745c94-8cf5-405d-b233-61ebdcfc67f8	\N	reset-credentials-choose-user	MedLabMS	88ab87c9-0eb2-4753-a6d3-3af24b53fb8d	0	10	f	\N	\N
9b1a642b-ca9b-4a88-8806-78de1d2584ee	\N	reset-credential-email	MedLabMS	88ab87c9-0eb2-4753-a6d3-3af24b53fb8d	0	20	f	\N	\N
560468f7-95a3-48c3-b7aa-ae0c7a9258b7	\N	reset-password	MedLabMS	88ab87c9-0eb2-4753-a6d3-3af24b53fb8d	0	30	f	\N	\N
6aa8a645-bea0-4e41-86e8-5c51001d8c69	\N	\N	MedLabMS	88ab87c9-0eb2-4753-a6d3-3af24b53fb8d	1	40	t	fb6733ba-1eef-4d3b-9c65-37622af1c8c3	\N
302fd106-0b27-4668-8655-c5dbeab4bcd1	\N	conditional-user-configured	MedLabMS	fb6733ba-1eef-4d3b-9c65-37622af1c8c3	0	10	f	\N	\N
207de6eb-b347-4f34-b020-41e793692245	\N	reset-otp	MedLabMS	fb6733ba-1eef-4d3b-9c65-37622af1c8c3	0	20	f	\N	\N
5aeb85a9-eb1a-492f-a815-dd90475ee930	\N	client-secret	MedLabMS	a34c1873-c0fd-438c-adb1-70193a7ac08a	2	10	f	\N	\N
288834d9-2935-46d1-b86b-64101ab2273b	\N	client-jwt	MedLabMS	a34c1873-c0fd-438c-adb1-70193a7ac08a	2	20	f	\N	\N
35fade90-d137-427b-8c86-b768723c99e8	\N	client-secret-jwt	MedLabMS	a34c1873-c0fd-438c-adb1-70193a7ac08a	2	30	f	\N	\N
903c203f-fdba-4082-b554-dd3c275150d8	\N	client-x509	MedLabMS	a34c1873-c0fd-438c-adb1-70193a7ac08a	2	40	f	\N	\N
4535a7d9-f6b7-43d1-8057-9c74c1f1b03b	\N	idp-review-profile	MedLabMS	4ef63f5c-bfe6-497e-8572-dd7e07ece834	0	10	f	\N	e12c29bf-82f4-4e8c-b38e-2a24ee6d134a
ef739416-fb3d-48c2-97fe-97ca0f73793b	\N	\N	MedLabMS	4ef63f5c-bfe6-497e-8572-dd7e07ece834	0	20	t	5b4781b1-704e-4df5-85bc-32e9a0895394	\N
688dcbf6-a175-4ab0-b0d4-fe122c94ff90	\N	idp-create-user-if-unique	MedLabMS	5b4781b1-704e-4df5-85bc-32e9a0895394	2	10	f	\N	389ffc23-d452-42cb-9cb0-15e561d5bcab
6deabf92-223a-48f1-a800-400af3433066	\N	\N	MedLabMS	5b4781b1-704e-4df5-85bc-32e9a0895394	2	20	t	39f266ae-569c-4276-932c-9a0c3f14aed4	\N
4d175422-98da-4a24-bca4-983a6f36d537	\N	idp-confirm-link	MedLabMS	39f266ae-569c-4276-932c-9a0c3f14aed4	0	10	f	\N	\N
2bbfaf49-0c73-40c3-bc39-a9b23d9377bd	\N	\N	MedLabMS	39f266ae-569c-4276-932c-9a0c3f14aed4	0	20	t	f9ad11a6-12f5-40e4-b324-ed80ebe3a5c2	\N
ef487ef1-bdff-4691-b0b3-013b89fae079	\N	idp-email-verification	MedLabMS	f9ad11a6-12f5-40e4-b324-ed80ebe3a5c2	2	10	f	\N	\N
405177ad-d47f-4ae2-bdf8-830663b3ccf7	\N	\N	MedLabMS	f9ad11a6-12f5-40e4-b324-ed80ebe3a5c2	2	20	t	2e1c2823-9b6e-4033-937a-4eb08a6b073f	\N
5fd2b184-8f24-4b8a-ab1e-c02da28b9b89	\N	idp-username-password-form	MedLabMS	2e1c2823-9b6e-4033-937a-4eb08a6b073f	0	10	f	\N	\N
0e338424-e728-4a30-89c5-14b8a2376ad1	\N	\N	MedLabMS	2e1c2823-9b6e-4033-937a-4eb08a6b073f	1	20	t	a827db1f-91fd-4264-98da-b63845c875cf	\N
778798cc-b5a2-498b-ab4f-f2622aa958cf	\N	conditional-user-configured	MedLabMS	a827db1f-91fd-4264-98da-b63845c875cf	0	10	f	\N	\N
b732ae25-37d3-4c6f-8053-65b90b316a1d	\N	auth-otp-form	MedLabMS	a827db1f-91fd-4264-98da-b63845c875cf	0	20	f	\N	\N
5a49020c-f019-4fe2-94ee-2800dc11740c	\N	http-basic-authenticator	MedLabMS	c86f246c-0c2c-4fb0-b11f-315fc5aaf912	0	10	f	\N	\N
4fe06bf4-7929-4e10-ba4d-594310e310b7	\N	docker-http-basic-authenticator	MedLabMS	bd97d87d-6293-42f9-8654-add42ec83c87	0	10	f	\N	\N
63e4c024-9a56-482d-8aa5-8638aab98108	\N	no-cookie-redirect	MedLabMS	b70065bc-d011-4b77-a5b0-8cae2cc33798	0	10	f	\N	\N
85829577-1a64-46e8-be74-f9820e1a351f	\N	\N	MedLabMS	b70065bc-d011-4b77-a5b0-8cae2cc33798	0	20	t	87453f79-21e3-4c4b-9089-e3c68129d3a7	\N
4ad95ce7-66e3-456f-8502-9e2572c1d967	\N	basic-auth	MedLabMS	87453f79-21e3-4c4b-9089-e3c68129d3a7	0	10	f	\N	\N
b3bb8d37-e02c-4c7d-aa6e-c667c0da074a	\N	basic-auth-otp	MedLabMS	87453f79-21e3-4c4b-9089-e3c68129d3a7	3	20	f	\N	\N
0df3eae8-e6be-4c42-8e9e-4397a901afc9	\N	auth-spnego	MedLabMS	87453f79-21e3-4c4b-9089-e3c68129d3a7	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
e831f332-635d-42fb-a7ee-6b14c6763a73	browser	browser based authentication	master	basic-flow	t	t
c13a46ce-3026-44e4-8968-c5b40c094378	forms	Username, password, otp and other auth forms.	master	basic-flow	f	t
c744c75b-752e-46b3-a4d1-0f0bd40df319	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
b0ddfd06-db22-4454-9f73-4f7eee64188f	direct grant	OpenID Connect Resource Owner Grant	master	basic-flow	t	t
c957fab9-39a9-489c-b2a6-212a883220ed	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
125c4be6-5a99-4994-b8ab-5bfc741306b1	registration	registration flow	master	basic-flow	t	t
f9e0b120-94dd-46f4-8ce1-c4b6711c18cd	registration form	registration form	master	form-flow	f	t
4ad9d0bf-5539-406c-9e20-432aa4369b49	reset credentials	Reset credentials for a user if they forgot their password or something	master	basic-flow	t	t
6c90c3d3-987e-4995-878f-a1b0d877b5ec	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	master	basic-flow	f	t
dc44410b-87e3-4c00-9f4a-649200dcf570	clients	Base authentication for clients	master	client-flow	t	t
c38c4d8d-14f4-4bfa-8114-d29fe79fb0fc	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	master	basic-flow	t	t
6b70b79a-58df-43c9-b327-319f380bce91	User creation or linking	Flow for the existing/non-existing user alternatives	master	basic-flow	f	t
42bca9f2-5ebf-4890-a44b-00c41d3e67ce	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	master	basic-flow	f	t
83334db3-8288-46ed-8eef-61b7f1e03c16	Account verification options	Method with which to verity the existing account	master	basic-flow	f	t
470182c3-1622-4666-8b7b-53a7ea0a338d	Verify Existing Account by Re-authentication	Reauthentication of existing account	master	basic-flow	f	t
01bd8464-370e-4550-b696-da327391cd59	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
956c3f4a-01de-416c-bbbc-e25783ca6cd1	saml ecp	SAML ECP Profile Authentication Flow	master	basic-flow	t	t
be78d0d6-9571-4cf6-b9f9-9c4410acfb41	docker auth	Used by Docker clients to authenticate against the IDP	master	basic-flow	t	t
6233233d-5482-4cd8-9732-b29482ba8f1a	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	master	basic-flow	t	t
7ba422e4-b527-40aa-979f-f5be5b5c1686	Authentication Options	Authentication options.	master	basic-flow	f	t
2237847d-6238-4ddb-aad4-d17914cdbf54	browser	browser based authentication	MedLabMS	basic-flow	t	t
5a7cca38-f150-4c44-8343-bef2d2a39306	forms	Username, password, otp and other auth forms.	MedLabMS	basic-flow	f	t
d1f6b2e1-bf8e-4c14-b827-94293a41e73a	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	MedLabMS	basic-flow	f	t
2f45d891-25d4-44cf-8787-582d54a64c9c	direct grant	OpenID Connect Resource Owner Grant	MedLabMS	basic-flow	t	t
36864c68-262c-492d-94b2-3b1f1d96eecc	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	MedLabMS	basic-flow	f	t
daddec87-b2be-4de0-a5cd-8a8ae26a195c	registration	registration flow	MedLabMS	basic-flow	t	t
f66a450b-c449-4a9a-b603-159da5147a45	registration form	registration form	MedLabMS	form-flow	f	t
88ab87c9-0eb2-4753-a6d3-3af24b53fb8d	reset credentials	Reset credentials for a user if they forgot their password or something	MedLabMS	basic-flow	t	t
fb6733ba-1eef-4d3b-9c65-37622af1c8c3	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	MedLabMS	basic-flow	f	t
a34c1873-c0fd-438c-adb1-70193a7ac08a	clients	Base authentication for clients	MedLabMS	client-flow	t	t
4ef63f5c-bfe6-497e-8572-dd7e07ece834	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	MedLabMS	basic-flow	t	t
5b4781b1-704e-4df5-85bc-32e9a0895394	User creation or linking	Flow for the existing/non-existing user alternatives	MedLabMS	basic-flow	f	t
39f266ae-569c-4276-932c-9a0c3f14aed4	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	MedLabMS	basic-flow	f	t
f9ad11a6-12f5-40e4-b324-ed80ebe3a5c2	Account verification options	Method with which to verity the existing account	MedLabMS	basic-flow	f	t
2e1c2823-9b6e-4033-937a-4eb08a6b073f	Verify Existing Account by Re-authentication	Reauthentication of existing account	MedLabMS	basic-flow	f	t
a827db1f-91fd-4264-98da-b63845c875cf	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	MedLabMS	basic-flow	f	t
c86f246c-0c2c-4fb0-b11f-315fc5aaf912	saml ecp	SAML ECP Profile Authentication Flow	MedLabMS	basic-flow	t	t
bd97d87d-6293-42f9-8654-add42ec83c87	docker auth	Used by Docker clients to authenticate against the IDP	MedLabMS	basic-flow	t	t
b70065bc-d011-4b77-a5b0-8cae2cc33798	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	MedLabMS	basic-flow	t	t
87453f79-21e3-4c4b-9089-e3c68129d3a7	Authentication Options	Authentication options.	MedLabMS	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
97d585f6-4d1e-47f6-92b7-be27bd2e3f02	review profile config	master
36900f37-0f82-483b-a033-58f74ddc86f3	create unique user config	master
e12c29bf-82f4-4e8c-b38e-2a24ee6d134a	review profile config	MedLabMS
389ffc23-d452-42cb-9cb0-15e561d5bcab	create unique user config	MedLabMS
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
97d585f6-4d1e-47f6-92b7-be27bd2e3f02	missing	update.profile.on.first.login
36900f37-0f82-483b-a033-58f74ddc86f3	false	require.password.update.after.registration
e12c29bf-82f4-4e8c-b38e-2a24ee6d134a	missing	update.profile.on.first.login
389ffc23-d452-42cb-9cb0-15e561d5bcab	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
b912181c-b693-4335-a0bd-e4a7e4e5811d	t	f	master-realm	0	f	\N	\N	t	\N	f	master	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
c8751636-5463-4262-b11f-5d79831d4ac0	t	f	broker	0	f	\N	\N	t	\N	f	master	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
5279cdb1-a17d-4ab8-a091-8e909ee0d898	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	master	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
a7c33b14-ce45-439a-96b7-5dab82ee1306	t	f	admin-cli	0	t	\N	\N	f	\N	f	master	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
71250ec0-20be-40e0-b7c1-d07906469908	t	f	MedLabMS-realm	0	f	\N	\N	t	\N	f	master	\N	0	f	f	MedLabMS Realm	f	client-secret	\N	\N	\N	t	f	f	f
0d8a4179-d49a-412d-866c-7d920925bb4a	t	f	realm-management	0	f	\N	\N	t	\N	f	MedLabMS	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
709f81e4-9774-4ad5-9aa9-723903b1c90a	t	f	account	0	t	\N	/realms/MedLabMS/account/	f	\N	f	MedLabMS	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
9faaf662-da17-4f1c-91c8-e6cfb0794eef	t	f	account-console	0	t	\N	/realms/MedLabMS/account/	f	\N	f	MedLabMS	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	t	f	broker	0	f	\N	\N	t	\N	f	MedLabMS	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	t	f	security-admin-console	0	t	\N	/admin/MedLabMS/console/	f	\N	f	MedLabMS	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
5ad9ddce-142d-4b12-9b60-6285734fa976	t	f	admin-cli	0	t	\N	\N	f	\N	f	MedLabMS	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
50aab8c6-991d-4294-9b59-d9d59426ce08	t	t	ui-client	0	t	\N	\N	f	\N	f	MedLabMS	openid-connect	-1	f	f	\N	f	client-secret	\N	\N	\N	t	f	t	f
3ec008e8-b299-41da-a7e7-863e71dbc181	t	t	super-client	0	f	28d5561f-50a1-46e3-8882-d680864a6e3d	\N	f	\N	f	MedLabMS	openid-connect	-1	f	f	\N	t	client-secret	\N	\N	\N	f	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, value, name) FROM stdin;
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	S256	pkce.code.challenge.method
5279cdb1-a17d-4ab8-a091-8e909ee0d898	S256	pkce.code.challenge.method
9faaf662-da17-4f1c-91c8-e6cfb0794eef	S256	pkce.code.challenge.method
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	S256	pkce.code.challenge.method
50aab8c6-991d-4294-9b59-d9d59426ce08	true	backchannel.logout.session.required
50aab8c6-991d-4294-9b59-d9d59426ce08	false	backchannel.logout.revoke.offline.tokens
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.artifact.binding
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.server.signature
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.server.signature.keyinfo.ext
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.assertion.signature
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.client.signature
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.encrypt
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.authnstatement
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.onetimeuse.condition
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml_force_name_id_format
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.multivalued.roles
50aab8c6-991d-4294-9b59-d9d59426ce08	false	saml.force.post.binding
50aab8c6-991d-4294-9b59-d9d59426ce08	false	exclude.session.state.from.auth.response
50aab8c6-991d-4294-9b59-d9d59426ce08	false	oauth2.device.authorization.grant.enabled
50aab8c6-991d-4294-9b59-d9d59426ce08	false	oidc.ciba.grant.enabled
50aab8c6-991d-4294-9b59-d9d59426ce08	true	use.refresh.tokens
50aab8c6-991d-4294-9b59-d9d59426ce08	false	id.token.as.detached.signature
50aab8c6-991d-4294-9b59-d9d59426ce08	false	tls.client.certificate.bound.access.tokens
50aab8c6-991d-4294-9b59-d9d59426ce08	false	require.pushed.authorization.requests
50aab8c6-991d-4294-9b59-d9d59426ce08	false	client_credentials.use_refresh_token
50aab8c6-991d-4294-9b59-d9d59426ce08	false	display.on.consent.screen
3ec008e8-b299-41da-a7e7-863e71dbc181	true	backchannel.logout.session.required
3ec008e8-b299-41da-a7e7-863e71dbc181	false	backchannel.logout.revoke.offline.tokens
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.artifact.binding
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.server.signature
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.server.signature.keyinfo.ext
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.assertion.signature
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.client.signature
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.encrypt
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.authnstatement
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.onetimeuse.condition
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml_force_name_id_format
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.multivalued.roles
3ec008e8-b299-41da-a7e7-863e71dbc181	false	saml.force.post.binding
3ec008e8-b299-41da-a7e7-863e71dbc181	false	exclude.session.state.from.auth.response
3ec008e8-b299-41da-a7e7-863e71dbc181	false	oauth2.device.authorization.grant.enabled
3ec008e8-b299-41da-a7e7-863e71dbc181	false	oidc.ciba.grant.enabled
3ec008e8-b299-41da-a7e7-863e71dbc181	true	use.refresh.tokens
3ec008e8-b299-41da-a7e7-863e71dbc181	false	id.token.as.detached.signature
3ec008e8-b299-41da-a7e7-863e71dbc181	false	tls.client.certificate.bound.access.tokens
3ec008e8-b299-41da-a7e7-863e71dbc181	false	require.pushed.authorization.requests
3ec008e8-b299-41da-a7e7-863e71dbc181	false	client_credentials.use_refresh_token
3ec008e8-b299-41da-a7e7-863e71dbc181	false	display.on.consent.screen
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
e3b0d39f-67aa-4233-8930-735a3fc393e8	offline_access	master	OpenID Connect built-in scope: offline_access	openid-connect
a6bd6e2f-ed7b-4e2e-b0ee-cda7652d9843	role_list	master	SAML role list	saml
fefa0369-b392-4ed7-abc9-3ed0d2c162ea	profile	master	OpenID Connect built-in scope: profile	openid-connect
8bba7965-1661-4d41-b102-996127f8f36d	email	master	OpenID Connect built-in scope: email	openid-connect
07508c3e-8cc5-4957-98a0-66423972c2ab	address	master	OpenID Connect built-in scope: address	openid-connect
98165bda-fe2e-421f-9041-621095eeb48b	phone	master	OpenID Connect built-in scope: phone	openid-connect
9fc14758-e341-4d37-9ab7-08a662539828	roles	master	OpenID Connect scope for add user roles to the access token	openid-connect
4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	web-origins	master	OpenID Connect scope for add allowed web origins to the access token	openid-connect
6f681922-b2fc-489b-8569-e29f9280723b	microprofile-jwt	master	Microprofile - JWT built-in scope	openid-connect
c101cbbe-37da-4aba-a646-20cffd87e257	offline_access	MedLabMS	OpenID Connect built-in scope: offline_access	openid-connect
aad5c8fa-cfd9-4313-9c6b-a001547ad0ec	role_list	MedLabMS	SAML role list	saml
18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	profile	MedLabMS	OpenID Connect built-in scope: profile	openid-connect
8cf85305-c87a-42de-bfb7-e71d6fcdde77	email	MedLabMS	OpenID Connect built-in scope: email	openid-connect
fee62b7d-2a34-41de-b29b-6a9bb4465f68	address	MedLabMS	OpenID Connect built-in scope: address	openid-connect
b5866938-46b4-41db-bc1f-910f32a92a7e	phone	MedLabMS	OpenID Connect built-in scope: phone	openid-connect
943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	roles	MedLabMS	OpenID Connect scope for add user roles to the access token	openid-connect
c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	web-origins	MedLabMS	OpenID Connect scope for add allowed web origins to the access token	openid-connect
c98ee8cd-4148-486c-a90d-39a2668f15b0	microprofile-jwt	MedLabMS	Microprofile - JWT built-in scope	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
e3b0d39f-67aa-4233-8930-735a3fc393e8	true	display.on.consent.screen
e3b0d39f-67aa-4233-8930-735a3fc393e8	${offlineAccessScopeConsentText}	consent.screen.text
a6bd6e2f-ed7b-4e2e-b0ee-cda7652d9843	true	display.on.consent.screen
a6bd6e2f-ed7b-4e2e-b0ee-cda7652d9843	${samlRoleListScopeConsentText}	consent.screen.text
fefa0369-b392-4ed7-abc9-3ed0d2c162ea	true	display.on.consent.screen
fefa0369-b392-4ed7-abc9-3ed0d2c162ea	${profileScopeConsentText}	consent.screen.text
fefa0369-b392-4ed7-abc9-3ed0d2c162ea	true	include.in.token.scope
8bba7965-1661-4d41-b102-996127f8f36d	true	display.on.consent.screen
8bba7965-1661-4d41-b102-996127f8f36d	${emailScopeConsentText}	consent.screen.text
8bba7965-1661-4d41-b102-996127f8f36d	true	include.in.token.scope
07508c3e-8cc5-4957-98a0-66423972c2ab	true	display.on.consent.screen
07508c3e-8cc5-4957-98a0-66423972c2ab	${addressScopeConsentText}	consent.screen.text
07508c3e-8cc5-4957-98a0-66423972c2ab	true	include.in.token.scope
98165bda-fe2e-421f-9041-621095eeb48b	true	display.on.consent.screen
98165bda-fe2e-421f-9041-621095eeb48b	${phoneScopeConsentText}	consent.screen.text
98165bda-fe2e-421f-9041-621095eeb48b	true	include.in.token.scope
9fc14758-e341-4d37-9ab7-08a662539828	true	display.on.consent.screen
9fc14758-e341-4d37-9ab7-08a662539828	${rolesScopeConsentText}	consent.screen.text
9fc14758-e341-4d37-9ab7-08a662539828	false	include.in.token.scope
4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	false	display.on.consent.screen
4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c		consent.screen.text
4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	false	include.in.token.scope
6f681922-b2fc-489b-8569-e29f9280723b	false	display.on.consent.screen
6f681922-b2fc-489b-8569-e29f9280723b	true	include.in.token.scope
c101cbbe-37da-4aba-a646-20cffd87e257	true	display.on.consent.screen
c101cbbe-37da-4aba-a646-20cffd87e257	${offlineAccessScopeConsentText}	consent.screen.text
aad5c8fa-cfd9-4313-9c6b-a001547ad0ec	true	display.on.consent.screen
aad5c8fa-cfd9-4313-9c6b-a001547ad0ec	${samlRoleListScopeConsentText}	consent.screen.text
18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	true	display.on.consent.screen
18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	${profileScopeConsentText}	consent.screen.text
18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	true	include.in.token.scope
8cf85305-c87a-42de-bfb7-e71d6fcdde77	true	display.on.consent.screen
8cf85305-c87a-42de-bfb7-e71d6fcdde77	${emailScopeConsentText}	consent.screen.text
8cf85305-c87a-42de-bfb7-e71d6fcdde77	true	include.in.token.scope
fee62b7d-2a34-41de-b29b-6a9bb4465f68	true	display.on.consent.screen
fee62b7d-2a34-41de-b29b-6a9bb4465f68	${addressScopeConsentText}	consent.screen.text
fee62b7d-2a34-41de-b29b-6a9bb4465f68	true	include.in.token.scope
b5866938-46b4-41db-bc1f-910f32a92a7e	true	display.on.consent.screen
b5866938-46b4-41db-bc1f-910f32a92a7e	${phoneScopeConsentText}	consent.screen.text
b5866938-46b4-41db-bc1f-910f32a92a7e	true	include.in.token.scope
943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	true	display.on.consent.screen
943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	${rolesScopeConsentText}	consent.screen.text
943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	false	include.in.token.scope
c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	false	display.on.consent.screen
c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb		consent.screen.text
c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	false	include.in.token.scope
c98ee8cd-4148-486c-a90d-39a2668f15b0	false	display.on.consent.screen
c98ee8cd-4148-486c-a90d-39a2668f15b0	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	9fc14758-e341-4d37-9ab7-08a662539828	t
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	8bba7965-1661-4d41-b102-996127f8f36d	t
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	07508c3e-8cc5-4957-98a0-66423972c2ab	f
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	98165bda-fe2e-421f-9041-621095eeb48b	f
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	6f681922-b2fc-489b-8569-e29f9280723b	f
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	9fc14758-e341-4d37-9ab7-08a662539828	t
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	8bba7965-1661-4d41-b102-996127f8f36d	t
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	07508c3e-8cc5-4957-98a0-66423972c2ab	f
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	98165bda-fe2e-421f-9041-621095eeb48b	f
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	6f681922-b2fc-489b-8569-e29f9280723b	f
a7c33b14-ce45-439a-96b7-5dab82ee1306	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
a7c33b14-ce45-439a-96b7-5dab82ee1306	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
a7c33b14-ce45-439a-96b7-5dab82ee1306	9fc14758-e341-4d37-9ab7-08a662539828	t
a7c33b14-ce45-439a-96b7-5dab82ee1306	8bba7965-1661-4d41-b102-996127f8f36d	t
a7c33b14-ce45-439a-96b7-5dab82ee1306	07508c3e-8cc5-4957-98a0-66423972c2ab	f
a7c33b14-ce45-439a-96b7-5dab82ee1306	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
a7c33b14-ce45-439a-96b7-5dab82ee1306	98165bda-fe2e-421f-9041-621095eeb48b	f
a7c33b14-ce45-439a-96b7-5dab82ee1306	6f681922-b2fc-489b-8569-e29f9280723b	f
c8751636-5463-4262-b11f-5d79831d4ac0	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
c8751636-5463-4262-b11f-5d79831d4ac0	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
c8751636-5463-4262-b11f-5d79831d4ac0	9fc14758-e341-4d37-9ab7-08a662539828	t
c8751636-5463-4262-b11f-5d79831d4ac0	8bba7965-1661-4d41-b102-996127f8f36d	t
c8751636-5463-4262-b11f-5d79831d4ac0	07508c3e-8cc5-4957-98a0-66423972c2ab	f
c8751636-5463-4262-b11f-5d79831d4ac0	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
c8751636-5463-4262-b11f-5d79831d4ac0	98165bda-fe2e-421f-9041-621095eeb48b	f
c8751636-5463-4262-b11f-5d79831d4ac0	6f681922-b2fc-489b-8569-e29f9280723b	f
b912181c-b693-4335-a0bd-e4a7e4e5811d	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
b912181c-b693-4335-a0bd-e4a7e4e5811d	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
b912181c-b693-4335-a0bd-e4a7e4e5811d	9fc14758-e341-4d37-9ab7-08a662539828	t
b912181c-b693-4335-a0bd-e4a7e4e5811d	8bba7965-1661-4d41-b102-996127f8f36d	t
b912181c-b693-4335-a0bd-e4a7e4e5811d	07508c3e-8cc5-4957-98a0-66423972c2ab	f
b912181c-b693-4335-a0bd-e4a7e4e5811d	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
b912181c-b693-4335-a0bd-e4a7e4e5811d	98165bda-fe2e-421f-9041-621095eeb48b	f
b912181c-b693-4335-a0bd-e4a7e4e5811d	6f681922-b2fc-489b-8569-e29f9280723b	f
5279cdb1-a17d-4ab8-a091-8e909ee0d898	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
5279cdb1-a17d-4ab8-a091-8e909ee0d898	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
5279cdb1-a17d-4ab8-a091-8e909ee0d898	9fc14758-e341-4d37-9ab7-08a662539828	t
5279cdb1-a17d-4ab8-a091-8e909ee0d898	8bba7965-1661-4d41-b102-996127f8f36d	t
5279cdb1-a17d-4ab8-a091-8e909ee0d898	07508c3e-8cc5-4957-98a0-66423972c2ab	f
5279cdb1-a17d-4ab8-a091-8e909ee0d898	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
5279cdb1-a17d-4ab8-a091-8e909ee0d898	98165bda-fe2e-421f-9041-621095eeb48b	f
5279cdb1-a17d-4ab8-a091-8e909ee0d898	6f681922-b2fc-489b-8569-e29f9280723b	f
709f81e4-9774-4ad5-9aa9-723903b1c90a	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
709f81e4-9774-4ad5-9aa9-723903b1c90a	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
709f81e4-9774-4ad5-9aa9-723903b1c90a	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
709f81e4-9774-4ad5-9aa9-723903b1c90a	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
709f81e4-9774-4ad5-9aa9-723903b1c90a	b5866938-46b4-41db-bc1f-910f32a92a7e	f
709f81e4-9774-4ad5-9aa9-723903b1c90a	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
709f81e4-9774-4ad5-9aa9-723903b1c90a	c101cbbe-37da-4aba-a646-20cffd87e257	f
709f81e4-9774-4ad5-9aa9-723903b1c90a	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
9faaf662-da17-4f1c-91c8-e6cfb0794eef	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
9faaf662-da17-4f1c-91c8-e6cfb0794eef	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
9faaf662-da17-4f1c-91c8-e6cfb0794eef	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
9faaf662-da17-4f1c-91c8-e6cfb0794eef	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
9faaf662-da17-4f1c-91c8-e6cfb0794eef	b5866938-46b4-41db-bc1f-910f32a92a7e	f
9faaf662-da17-4f1c-91c8-e6cfb0794eef	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
9faaf662-da17-4f1c-91c8-e6cfb0794eef	c101cbbe-37da-4aba-a646-20cffd87e257	f
9faaf662-da17-4f1c-91c8-e6cfb0794eef	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
5ad9ddce-142d-4b12-9b60-6285734fa976	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
5ad9ddce-142d-4b12-9b60-6285734fa976	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
5ad9ddce-142d-4b12-9b60-6285734fa976	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
5ad9ddce-142d-4b12-9b60-6285734fa976	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
5ad9ddce-142d-4b12-9b60-6285734fa976	b5866938-46b4-41db-bc1f-910f32a92a7e	f
5ad9ddce-142d-4b12-9b60-6285734fa976	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
5ad9ddce-142d-4b12-9b60-6285734fa976	c101cbbe-37da-4aba-a646-20cffd87e257	f
5ad9ddce-142d-4b12-9b60-6285734fa976	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	b5866938-46b4-41db-bc1f-910f32a92a7e	f
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	c101cbbe-37da-4aba-a646-20cffd87e257	f
b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
0d8a4179-d49a-412d-866c-7d920925bb4a	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
0d8a4179-d49a-412d-866c-7d920925bb4a	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
0d8a4179-d49a-412d-866c-7d920925bb4a	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
0d8a4179-d49a-412d-866c-7d920925bb4a	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
0d8a4179-d49a-412d-866c-7d920925bb4a	b5866938-46b4-41db-bc1f-910f32a92a7e	f
0d8a4179-d49a-412d-866c-7d920925bb4a	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
0d8a4179-d49a-412d-866c-7d920925bb4a	c101cbbe-37da-4aba-a646-20cffd87e257	f
0d8a4179-d49a-412d-866c-7d920925bb4a	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	b5866938-46b4-41db-bc1f-910f32a92a7e	f
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	c101cbbe-37da-4aba-a646-20cffd87e257	f
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
50aab8c6-991d-4294-9b59-d9d59426ce08	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
50aab8c6-991d-4294-9b59-d9d59426ce08	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
50aab8c6-991d-4294-9b59-d9d59426ce08	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
50aab8c6-991d-4294-9b59-d9d59426ce08	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
50aab8c6-991d-4294-9b59-d9d59426ce08	b5866938-46b4-41db-bc1f-910f32a92a7e	f
50aab8c6-991d-4294-9b59-d9d59426ce08	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
50aab8c6-991d-4294-9b59-d9d59426ce08	c101cbbe-37da-4aba-a646-20cffd87e257	f
50aab8c6-991d-4294-9b59-d9d59426ce08	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
3ec008e8-b299-41da-a7e7-863e71dbc181	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
3ec008e8-b299-41da-a7e7-863e71dbc181	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
3ec008e8-b299-41da-a7e7-863e71dbc181	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
3ec008e8-b299-41da-a7e7-863e71dbc181	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
3ec008e8-b299-41da-a7e7-863e71dbc181	b5866938-46b4-41db-bc1f-910f32a92a7e	f
3ec008e8-b299-41da-a7e7-863e71dbc181	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
3ec008e8-b299-41da-a7e7-863e71dbc181	c101cbbe-37da-4aba-a646-20cffd87e257	f
3ec008e8-b299-41da-a7e7-863e71dbc181	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
e3b0d39f-67aa-4233-8930-735a3fc393e8	48fdff74-2175-4dcf-9edf-073f2fd50cda
c101cbbe-37da-4aba-a646-20cffd87e257	75e44024-527f-4375-80f6-6427406420c6
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
3fa91e5e-6074-4c85-88f9-77bbec385487	Trusted Hosts	master	trusted-hosts	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
e9cc1896-014d-4742-baad-370113bc03ea	Consent Required	master	consent-required	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
39b7098c-3ed2-4de8-a6c2-66a0cbcf2966	Full Scope Disabled	master	scope	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
5f5d935f-76ac-4af0-9484-50e97d2250b6	Max Clients Limit	master	max-clients	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
63c5b24d-98df-4815-9ed6-544fdb387064	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
1da4bfae-d051-4544-b5ce-ba86ac7c0db6	Allowed Client Scopes	master	allowed-client-templates	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
f1f80530-5c3a-4c93-b0b8-fc69506f2651	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
65616902-f6b8-4b8f-98bd-6a575309a3fb	Allowed Client Scopes	master	allowed-client-templates	org.public.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
462286ae-6ac2-44b6-ac28-8bcad7294461	rsa-generated	master	rsa-generated	org.public.keys.KeyProvider	master	\N
b7e8195d-5dba-4074-9152-e13db0aff136	rsa-enc-generated	master	rsa-generated	org.public.keys.KeyProvider	master	\N
ae9d05f6-f672-42bb-83a4-530da2171885	hmac-generated	master	hmac-generated	org.public.keys.KeyProvider	master	\N
df2b96c1-08a9-4eb7-a131-34121c6e59e4	aes-generated	master	aes-generated	org.public.keys.KeyProvider	master	\N
163f5eca-875e-497f-ba38-fe7712626a8e	rsa-generated	MedLabMS	rsa-generated	org.public.keys.KeyProvider	MedLabMS	\N
3dc054ae-b43f-4abd-87c5-5d1e63733161	rsa-enc-generated	MedLabMS	rsa-generated	org.public.keys.KeyProvider	MedLabMS	\N
9d0d7c2f-d807-4247-becc-440efa77df7a	hmac-generated	MedLabMS	hmac-generated	org.public.keys.KeyProvider	MedLabMS	\N
27ef7eee-b1f9-451a-9f30-08397cf0529d	aes-generated	MedLabMS	aes-generated	org.public.keys.KeyProvider	MedLabMS	\N
beadb83a-f598-4e0b-b93a-b615b775a4ab	Trusted Hosts	MedLabMS	trusted-hosts	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	anonymous
76abadd4-b1a7-4dff-b6f5-8f4f7d2f63df	Consent Required	MedLabMS	consent-required	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	anonymous
c9e593dc-2dfc-42f4-a320-ba1d88f0a3e9	Full Scope Disabled	MedLabMS	scope	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	anonymous
e77095d7-e75b-4aa7-a3c4-5dc10b5a341b	Max Clients Limit	MedLabMS	max-clients	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	anonymous
7b22f5f1-7f2f-40df-913d-b91ff2c35699	Allowed Protocol Mapper Types	MedLabMS	allowed-protocol-mappers	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	anonymous
e9238a6f-dcf1-49a2-83ad-68a8a81d19cf	Allowed Client Scopes	MedLabMS	allowed-client-templates	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	anonymous
0e627819-bcf0-44b9-8d12-6b3025270bb4	Allowed Protocol Mapper Types	MedLabMS	allowed-protocol-mappers	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	authenticated
63f8679f-351d-41a4-b650-32f32249b820	Allowed Client Scopes	MedLabMS	allowed-client-templates	org.public.services.clientregistration.policy.ClientRegistrationPolicy	MedLabMS	authenticated
f4c3b156-f755-4566-8fd8-534cdc86dbf3	\N	MedLabMS	declarative-user-profile	org.public.userprofile.UserProfileProvider	MedLabMS	\N
f378ac31-b9af-4f88-9de7-9c5d82617312	fallback-HS256	master	hmac-generated	org.keycloak.keys.KeyProvider	master	\N
cb73598c-5099-4927-9fba-902324167b6b	fallback-RS256	master	rsa-generated	org.keycloak.keys.KeyProvider	master	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
89b0dae3-e8a3-4fe6-99e2-6c30fa544535	1da4bfae-d051-4544-b5ce-ba86ac7c0db6	allow-default-scopes	true
516aa1a9-4883-4d12-ae57-19199f8eb3e4	5f5d935f-76ac-4af0-9484-50e97d2250b6	max-clients	200
04ff2a5b-51bb-433c-9b45-6016dea9c0f8	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
83524e8e-176e-4652-a473-d7dd90be5c78	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
eaa34bae-9413-4a36-bc5c-a2bff16c1936	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	oidc-full-name-mapper
6c8bb127-5551-4a28-9abf-9bd43cbe9384	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	saml-user-attribute-mapper
bd56ebff-1a31-4518-9aa0-25ff2647b3b5	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	oidc-address-mapper
97579252-b734-4bda-82db-2c3d5d328547	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	saml-user-property-mapper
daf86059-e4d3-45cd-bba7-415edb1babb7	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
8b5634cb-1d2a-4271-b55d-e3bd9cd107a0	63c5b24d-98df-4815-9ed6-544fdb387064	allowed-protocol-mapper-types	saml-role-list-mapper
ff0d905a-baff-4f56-b260-ea7bdbf0eb8d	3fa91e5e-6074-4c85-88f9-77bbec385487	client-uris-must-match	true
d8ae64d9-ef7a-4311-8894-d170f29f52fa	3fa91e5e-6074-4c85-88f9-77bbec385487	host-sending-registration-request-must-match	true
ac222903-364a-4855-8aa0-a7c65e1d66fc	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	oidc-full-name-mapper
37f526c3-a45c-4da7-962e-603a69efb294	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	saml-user-property-mapper
8cf5ebea-f982-40aa-8875-a507efe4946c	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
aaebd647-ead3-4bfa-af2d-def52b287b76	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	saml-user-attribute-mapper
ce558f92-c6b8-410f-872a-47a38b3e69fa	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
542505e5-2779-4476-9946-4170e8d6c12d	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	oidc-address-mapper
208736d7-60d9-4d81-9193-7b54e408303c	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
6f885e63-877a-401f-b6e3-6f61adb20d3a	f1f80530-5c3a-4c93-b0b8-fc69506f2651	allowed-protocol-mapper-types	saml-role-list-mapper
4700f827-504c-4093-94a6-fb407a60a891	65616902-f6b8-4b8f-98bd-6a575309a3fb	allow-default-scopes	true
7884fef2-2615-48e3-bae2-7304b52bedb7	ae9d05f6-f672-42bb-83a4-530da2171885	kid	8eed2927-d234-428a-b62c-ea42b37c5937
52311154-5161-4d17-8c72-3b122c186c31	ae9d05f6-f672-42bb-83a4-530da2171885	algorithm	HS256
a339eed8-0270-4e37-9b10-eb9efb03d7b4	ae9d05f6-f672-42bb-83a4-530da2171885	priority	100
ab68b1a5-6655-4fb2-9bd2-0bfaf33c04d1	ae9d05f6-f672-42bb-83a4-530da2171885	secret	RZcQJeMOe5qNLAuTYr9bs8LCCKU_V8bibFFWpf9CaFRpymFzw63l2UfgKz4hHRiz45ZGMXFIR_kjmw0x8v-NiQ
ad8ebfd3-c95c-4f7f-b15e-6b964c7562cf	b7e8195d-5dba-4074-9152-e13db0aff136	priority	100
bd2904a7-49e7-4c15-8ba1-9fbb0b422995	b7e8195d-5dba-4074-9152-e13db0aff136	keyUse	enc
57ca7152-005f-49b2-9900-bd213bf353a5	b7e8195d-5dba-4074-9152-e13db0aff136	privateKey	MIIEowIBAAKCAQEAiOitZpeuXUyVCwfLmbWtW0ffOM0RwJMeABUHCcn8LhiJ5peyuUgOtB/AsnjztfcmjZkeN/JWAgi1syC8TZHTfzqh1eNATEyHXLkDEaMC4HkDjKVoEhsBFV+2tiJJ/4zYqRXIONHbIQ3qgn+Dt1EnCBpP6zrokrDVxPRhKPSCt8ieSrGUVgC7PG7aolZNUdccuOYWM4hRQh6KL/tzQSR1510ROaegybNb5nFuzx8otnKouYD4AtgL9r8TVI4yvozuxPWzCKZ56em/tyXeyopWhz6SFxRCWMzyIiTT2E9FqusXXceavdPJlSXLI0ApXSqIlML4id2pjo3QuCeHjpcy7wIDAQABAoIBAE7bViUlcLUkiyRTVR4v2q4c86HP3E3DbyA0/FzTDoGueJ9s+PBnZLCzKVai/BzvQjGE5DbtSkTZp26JiGxVdjBuIREFV9+apMzvc6kQ73NDwJueGhdznmglPSQjE+QxyAl8FltD5KdhUJXhxIguIgE0xpuCzrrPSBGtgNkKHNClyB47OC+VuavmgFE6HUbYcIwTmqjGzrWKm8RSi+o7MMxJwYWcICT4d/vKjnBV3wPG7C3OARmPf3Cr1+bdHmibJS/s2bgPuP08yRfAa217dCBvSMyYMVxfw9lczNJjyyk/61hgPlXIdzLieIuCjS9PD9+n60g87e3xajnS0DxewUECgYEA+x+ZSIgsuvHqfb3kpKCBhXhVl6Ba++p3gxAYUXNYT6K+VlXhLH45NCWVAknhRBd6S3JgBLu3/T2wVNE2oxr/H/J/IAz+KGf8SCBXBQJ6QbPZWi1dhfbbRpdui6SEgwrqmnlXEPtwq0Tr7rQMae3akoGlDpSxubsgRj1PoWuLYRkCgYEAi5FJra/ys1/PjuPGxG/5Hjvlw5WG9yCFWqEo+69P/pyMn7ZoQar89Nxgw0D8ysHskHZJyMW5X8A5W3P7KDDgXwKE1Po8sokF3apUUooHxP2w10Ji2FjSViopZTT0TwdV/SzYVfWqdNqQUcz1yM7oO2uwU7LfBC3SBOkN7CopDUcCgYEAkJ2A22k4QSxBesoZWsjn7eH/gIMjAkHjM0HYj0daivnQnM12D/ZcoPAnoJrFND5E+h/StccYzKhy3FVjHojUdSRkGyQAVWqUuUCOfF8R4rZcq/bGDfi8DCn2ykoi2Yg21GCeSDRUjPzy1ZMwNux327j3Qa9VrfzaODjkm7PgHzkCgYAHQN/BZRmJ9PrGhFP6NY+O4LIKPiUrhscndKS6n9vacaxlSIeWkhpfZ2yn+SKqLvXqdBtVkeEWdtkERbzR0+h1R547q12oMbLaWFXVjFLnDAA6z7pvX/5eeAZ6ugvQZ6Myazg7D29yb0F83tgPPaGYJPqe/vbUMsVtd+c/VNmZVQKBgH1s+Aci7Ea/ZkMwDKBempdRW3CoZ86r0QRukPj+N2BjrmzsB2NVSIWrbmPoBSW80I58cXL9dxyLraste8ielC8CkE+DntpLRfBuVSj7hg25/2HZBAe4AyjDzLielySUKmUMOzMnoY17BqBJeIvbk5xfm1AaN7O3/lB1V7LOW+PE
a5c55288-9d9d-4187-a96c-74dadb973e90	b7e8195d-5dba-4074-9152-e13db0aff136	certificate	MIICmzCCAYMCBgF84rA0eDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjExMTAyMjIwNDMxWhcNMzExMTAyMjIwNjExWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCI6K1ml65dTJULB8uZta1bR984zRHAkx4AFQcJyfwuGInml7K5SA60H8CyePO19yaNmR438lYCCLWzILxNkdN/OqHV40BMTIdcuQMRowLgeQOMpWgSGwEVX7a2Ikn/jNipFcg40dshDeqCf4O3UScIGk/rOuiSsNXE9GEo9IK3yJ5KsZRWALs8btqiVk1R1xy45hYziFFCHoov+3NBJHXnXRE5p6DJs1vmcW7PHyi2cqi5gPgC2Av2vxNUjjK+jO7E9bMIpnnp6b+3Jd7KilaHPpIXFEJYzPIiJNPYT0Wq6xddx5q908mVJcsjQCldKoiUwviJ3amOjdC4J4eOlzLvAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAG0Zq+ihZbsCFbkqo5U9NoH0veElnx6ZhdjIXNbxJ7HlryQaqDrR2yicg2w8hwulA+nkDI07yvi7OUAiFvxgxkLKLZT+Drs+eJ8olxDiwgxrbia8HlpDJEX0IIfqkOQNcVkF1Kg5CMT1pt35hQJnxXeYhkN/YS7gm8OsfmcUS1EHMcFY2GWrUtrrmE/E+7wRzo2OGW8baCBa5/n2YtKNdoroqpDy5EhB0oAAOojYH85xu8LPGlmaSOOkDkEKEdSbPcMyd6lgKY6sL1KrUnGpbTcEbFgA6fpz+QURkMQeBpoblHqosSMT/odfTMuwC36QgaGMrafTxeWYc91d720MaV0=
73404f01-8559-4d38-a07b-9f0eda671c08	df2b96c1-08a9-4eb7-a131-34121c6e59e4	priority	100
fb2ed50d-2d82-4ba9-8b46-4646662d546e	df2b96c1-08a9-4eb7-a131-34121c6e59e4	kid	6db75687-e1da-4856-860f-4f14fb368bf4
dc9d8b77-9e99-43bf-863d-3af3b77cab03	df2b96c1-08a9-4eb7-a131-34121c6e59e4	secret	nxr-Si9zzrUgrWSkTi9JdA
99d3b180-c1a7-4d52-be1d-0f425a6dbee0	462286ae-6ac2-44b6-ac28-8bcad7294461	keyUse	sig
a90f642a-ef8b-4ae0-98da-82885ebee371	462286ae-6ac2-44b6-ac28-8bcad7294461	certificate	MIICmzCCAYMCBgF84rAzoDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjExMTAyMjIwNDMwWhcNMzExMTAyMjIwNjEwWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC6sX6vd3emBnUnqk8K+LKqWu8Uc7imTC+qmR67YPtsAIJ0W1mFga8a0TxHiper2UTWIT1CYiBV8/xpK4+zoYI5AWn58Xh6n2802W3zetAfCSXCrNC5Veii1D4M6ZjKHQWO7Zr7cMTM4TlPLUuBymZeXU7TXsFmTuslOidO92+fHe0anBrgDx9pSNB81b/ygbDXjyAHNrE2Ssu4j2nWY62eOr4RznMYnuG1r7d3frwHBVK9dtLNQqiXUG4465DuneycTKP8k6J64I5aVtTdxo4Avr4izHy/PeEyXlq9iEO0Y7fN7zy0q2QfzM5I7v1S/+7xcr08R6kN0AIzF+K+vB7hAgMBAAEwDQYJKoZIhvcNAQELBQADggEBACtnPa+9EkQ4oftvL0Y/CWCZu+WnCfUz/yuEHQS6mYxLkATEg19CWyvbpqrOzrmhBUTwWV7YSZEGr4cQ0hxKAl3qAPhNEyPC7FtcUy1bZsjbklpusxPl47WS9zzwKGlwsZg//JduH00IVBM7mPFffMcZH9LwRiSDXzqS6ItlNQgm0DtojddSIdxMPY7AoGpWTpKGcz7Pz1lVmW4nqUuL8rkcfs1oMihQvuZJ43TlpdUOXHvfimZTM/OzbTyS33U5Az2de1ONOMKD/V36m5a9mK/QsBnHXJGItJ3yd+/yohFwxQWVlCPgrQFNKrsc6Z1eWV1+NpT6R0Rxyfv+p0PzCEs=
c4b7b651-797e-4312-b1f7-5ac22da112a3	462286ae-6ac2-44b6-ac28-8bcad7294461	priority	100
6bf04422-8a6e-4185-9bd5-f8ecec53b726	462286ae-6ac2-44b6-ac28-8bcad7294461	privateKey	MIIEpAIBAAKCAQEAurF+r3d3pgZ1J6pPCviyqlrvFHO4pkwvqpkeu2D7bACCdFtZhYGvGtE8R4qXq9lE1iE9QmIgVfP8aSuPs6GCOQFp+fF4ep9vNNlt83rQHwklwqzQuVXootQ+DOmYyh0Fju2a+3DEzOE5Ty1LgcpmXl1O017BZk7rJTonTvdvnx3tGpwa4A8faUjQfNW/8oGw148gBzaxNkrLuI9p1mOtnjq+Ec5zGJ7hta+3d368BwVSvXbSzUKol1BuOOuQ7p3snEyj/JOieuCOWlbU3caOAL6+Isx8vz3hMl5avYhDtGO3ze88tKtkH8zOSO79Uv/u8XK9PEepDdACMxfivrwe4QIDAQABAoIBAQC1H8rGtWMRYiZ7SxHQlSPRftOAxhyYykVcf51/MUH7sCrgdFfP3NdjbyfKSL2JbgsIq8rhAo5YlZOG/Uo3fjP21lZYtVqrrM6ZOXEgzT/pPFi0HDGL/brrbnqc0Gz5eVqRJhg8ZVWpZ8DP/iPJUfIrDt+Q1ddQSLR9s4O7aveSKC/hBt4MwcJ/zFrnkDQ4cMxz/IsRYMPtGOprvWzzs1R8CvpejeWXXETtDAl+6DHZ2Vgwo4fca6hfXpV7DVYhtLL8xss0Wx6Y6N1IgD0XbQDFQPA+QCLYp7PeXPSm/GWKqX1eewqmMMWIrJMXTVJUb/X3xdtqfuX7+0vi79XbzhuhAoGBAOToyQCyRm1PpeSPtKWrdrfdPMYi241k8IyLnyrl918WIU52v2NWEqEasL7zfNgoGhRD//SFaBx7iXtfmSg19UT/YNd/eAJFb00HTggXEVRQ+SEd8GaBuRs/1lsXSRH5k26cNiEesYaE/d1LIRgoGE9CQjqCtkZ1ys3LuFuYmIS9AoGBANDJs5qvA0Pk5YOCNedDASDynpCPt0OutPYQO0kCJ1wWMIVl3MGlDUD2Z7d6psm/fB47YUTrUsLi24kizGzdPQdu0iSvIyrRZB7gvu9jOc1tL6sEhR1Mm2QPTtI1d0+HM0zsNiC128xh6IaBIeKdq07m25dcvIE9C4bJ+GEJmc71AoGBAJiJ5yfnpLbDFLEychbUI9ByRUVjhRq74PBHOlHD3QwoGxnGV9NCUDe7KXyVlOQWFQrcJXw0SiRwzjTAh7cb/c10wHvaHYal7n1OGNmbRZkCPIGtCb3FRCy8ZYNeCPtJbM2QmyGG6pXRmboVjoAid9CZPrju0bgyVmq9DqU7EqehAoGAPN/SQfNtHEqMsH8ygC8FETosCTId2NoDYQryfiLmnu7JTtuYNc2Nw7cUHmbgYko2QgpGHfYOt0u1fpJq0ALhXF1vX8rAkidi7a3RfbKMk9yV3WL//L7tP4tHC/sSwllFF9R3I6piX4DcbvsPiic2X1boB4W+YGAQEEiq5oAKHFECgYA2lgpCraXAzyeRFoL0KCryrugGFB+hR+NSuSZ5Alr7n5KPSCvAqVlGUfqd4h7fZMphQidqvJzOsjIc/8ojvnKYXhrm3iKNYfw2uB1utT4l66Yi1IpWE46ttaXviHZOfQq6W98HbbYRbgwdbPanqBBLIY/ABVU1KERPa+pi5dzGXQ==
848151c6-f049-4679-9358-075555eed34f	27ef7eee-b1f9-451a-9f30-08397cf0529d	priority	100
5089b45d-c733-4c78-bd4f-b9d8882a6288	27ef7eee-b1f9-451a-9f30-08397cf0529d	kid	8ba8bc9a-fb8e-4a57-b050-acce1acc8ebf
0419b9eb-1b97-4aa2-8f7a-c1660f5d08e1	27ef7eee-b1f9-451a-9f30-08397cf0529d	secret	uheho4fLY5GNTcoUGJCmNg
82838b6f-00a2-489f-9370-8e30cc71d730	163f5eca-875e-497f-ba38-fe7712626a8e	certificate	MIICnzCCAYcCBgF84rNdRzANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhNZWRMYWJNUzAeFw0yMTExMDIyMjA3NThaFw0zMTExMDIyMjA5MzhaMBMxETAPBgNVBAMMCE1lZExhYk1TMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1XhhE4KKg+VVLyu5/7JhR22IluLscePRDFJaZrU1EDjRKLR8e2l4VZENvWQePU+Qf3MQVeBSDBJQMGJBJGOufKTyKvDyDEyk1Rlyw9qFA/bIV9tNsV20gZQG4KTnBE0F9iRFzWott+rXskVh4m6Hz5kdmLINDVt3x0alFbYUtNQH0nGBkKLOnTpFmRo+aVRFJH/60wlmtr6b8foFZ28mp6+G3am6EKtCAMeIBf5skXxhglBTDHd6/3sUBgrJC7zd6ZJSw8z1fsXRbTtj5N9jkM/Qqjqz5FaWozyAJQUzTpbxBzH94OaixD4xs/xqqudccsxHHQjfoWxJ7kTfap8rBwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBYBTWxBGPqunTO1Wc3NHh+q1/vmM+Pb1QvjnGCv9uonvHQyiyjxrvsP+25iJR9TOwt0ThbZUWZjYwGYNCPmQvAkdqKFgUTj0qR0iEqvGEuYnKWQR5hGLloKU0pJzt2IF61HKUTXtkkSQ2YHzIJnACE6z1/5W9BuRevxWV1SrCDhYqfR+vFE2fu//sECb/MiZygiICu5xO4dFYqvz+RA9A5OM9LwcIczkgrDGRADgAM8tDk8yp0oHPMff3KhGuPX//n4R4v0mYPBLiU8w8UA/dxELoWLx6Y+y+pPtCooxzhhj23JMViSXs+enZNb/b3tO1jTtEJt0H8QFXUVqzFY3tw
4a22ff7e-3cfa-4c7f-b825-043c5601f1ce	163f5eca-875e-497f-ba38-fe7712626a8e	keyUse	sig
34ae1c2a-5e97-438d-8e24-b44dc0c7f26c	163f5eca-875e-497f-ba38-fe7712626a8e	privateKey	MIIEpAIBAAKCAQEA1XhhE4KKg+VVLyu5/7JhR22IluLscePRDFJaZrU1EDjRKLR8e2l4VZENvWQePU+Qf3MQVeBSDBJQMGJBJGOufKTyKvDyDEyk1Rlyw9qFA/bIV9tNsV20gZQG4KTnBE0F9iRFzWott+rXskVh4m6Hz5kdmLINDVt3x0alFbYUtNQH0nGBkKLOnTpFmRo+aVRFJH/60wlmtr6b8foFZ28mp6+G3am6EKtCAMeIBf5skXxhglBTDHd6/3sUBgrJC7zd6ZJSw8z1fsXRbTtj5N9jkM/Qqjqz5FaWozyAJQUzTpbxBzH94OaixD4xs/xqqudccsxHHQjfoWxJ7kTfap8rBwIDAQABAoIBAQCRooHgFJQ5bbES8GsBtgnF+EVSY1haTslk9Z41KfUcrxaLBa9TZt4wyjgseGxk+a4kNTT00YhIMgpBKBc3I0Z8RO/uOdl4aKWfuK/iTGepD6kYv0Ye9kXajUmv4vC0r3OcvJxeiszMB8zGE623FB9Vkyls7jQXY8qwylKAIGu5/RqdCJTDUf+4VbqpL9MiCPO4kQJ+lXK6kix0U75Qbzzfc7ze0xu9uJmS5MThpAyMqU9za57qWhTKeqG9Y58jpnAY0n8zEvIRAaTA4DLC5WgEfvNOMFmalTY0mXuYJQO7fmtw80kQdzq/nmU//7PRdJX34jfLCTauF7SGnfpj+xBJAoGBAO5N7DF4osSpqg7xSMRaz6uyEn9TcIKNWoTpl34kUVi/Kqoofe4RFAGYlPG5BGNBhufMYbTmWJgapdAnKV2iIhTqHcU2OVRDXNeWD+wSejmDtmTRIT7anQ3rTh3pDhqaw7iItKpTwmjNoN4xZzcmNCyDW0ddR1SfrHjNQEjptHMdAoGBAOVSXltMp5mfneo/QOP86rNl/7FJoKLjmIIcdrDCv+s+G7+lkZt5crbnB8zwNb+J8v1nA9FmQm+lAy8EhNsD+gEbnFWvOzUnn7QDWuDr6dno34wlTGqvtnL6rsa4whswsH07+GwZQhiRAZPaUUAKGwOR+YMWqPnO3PZz5NszRjlzAoGBAOkAubN5X7Toq4VmuB59KFaZi2qBXB3aNiqE94H34q3iZMXxR4gRnL0ewmtC2x5tgIl+lf45x2AZlgzbbZ/GmopWivs71HwmTU3hxPmu62D2/sy+ikIZoLxuWXf3Wrn6nun8iKGNuiWdAPCf32rV6OepHAPAGbGNWibXkUZ5c92lAoGAJME27lsy4aR7ovfQZro6w9YtTTUH0hO4deIqA9qy9/lUaTsYQ1sLz9Tnoyk89B4gHA1Ox1kkfNBt2jNXN+NDRrouLG2Rh8t6BVgkULh/GrYAXm37+X2AOJ2FNcSXF9SN9QSPpIPH3DghkJkFPMZh3giffSs8mg1VzQp2O8vUDZECgYB2VAsf+Xw1aVBo7c4FDx9i+C3c/7fXPS4RS675P4aenSnmDOK6NfkN44AAW7ZVCODHMY6dXGmnGW38qY2Mnphbq2Rdgctg96jcDyWOswJs07SV78G2sWlnDmjdps0KKYzyPM/bXM+TuMdhK/D7vWSC7Qf+6wpubS3JaOII1ZQuRg==
fcf248c4-5537-493f-94a7-13ebdea7d1c1	163f5eca-875e-497f-ba38-fe7712626a8e	priority	100
d6d8bf9a-7093-4306-b13d-810e86d72abc	3dc054ae-b43f-4abd-87c5-5d1e63733161	priority	100
596c8e2e-272e-4014-9d79-04a70373f8db	3dc054ae-b43f-4abd-87c5-5d1e63733161	privateKey	MIIEowIBAAKCAQEAm0O0/aEnQweLVYu3GWB/18YY3tWx7axJOxG2UWfbrn4El/Asy/LtNpZQ2o8N3cNCcZlcmOHFiXRXhtLNu3ob1YgtehaERp5gZnD6RYHGRt+2yF3dPpPRgGzWEmKtngxB2Qaa8sTX4GOlMRTRIzEvEOf+jo/c71sjjFoNC8JDTTZtLKbx1sVogqisdbEIPMgFg5HFE9o876h8Sm27J1sbkPF2uDA08AptiJ+hpsWt11kR5vi7zzLAmaSU/gvhlx3MIu/+0D0aR4m3MsQeP884wrF0J5LTFPe3GO/gBYNJIkAGtxIyuxUHYpeoPO3u21kRaAUEwHVSK0mGuqqkUgh5jwIDAQABAoIBAFYz1y7h5EyAyckrEvNR8mi4IWLGvky41Meo49J6mStd5+r7e8OYEj+2YRmXRxmSqTcs8I4o+2V/ZIEEVRj7iKybOLSJ/9K9Z8Q4gZtJm+4Jkw/XnVh69VwaERiQFNik8YIu+qRCyaBZcoO3jQ2+5uS6CUjZcs6piSkJbijTKE6bQEzRggk39bcv8FrCIa0wf5sjvDcYkGI9CYQg2rhAclKVYmck2LAnJXvmwW78B09SdcRL/SxoKaRUj9C7Wd7qYx6YADxNWiEwdFb7uusRMSmpKNIF6973vaqtOw3ID8+4piP66XpLNW+GWbGVgZMWgQe0JfyHomKO6NLIfJDVJPECgYEA+QfTqMHBtU2/alkXJNozk1WjG5x3LNmX4QjoP7Z5bSsaSHe+K9/XEGGPym9GKWdvQvweKYC5ggbLS3UXNVZ9nEYM8q4sZDjBFRTxXvRm0llZImFnUp+Emvk/WDVuRCQ5vM2NaOBJQn4dq8r6Ah/SW6+I/WZ8SNuyTrl6p3u1Ec0CgYEAn5wYbRJMeG/JwXdxO6jPCJOWm6gRfrIFjFFrX7ZtkxP9VdEP3F2buDNtzLxHdHwdYtuzX1n141h6ug3vkyW0lxVVUKFX7/GGeR3WOTsyZIGA09PFjj4RS6PI+W6LttPV3sS+LN3CnE45Y9sdFt89HaoJ+44Ns2PQ8Zuce3hUzMsCgYEAjyLtiJEdqv0uKY1dnSQCAwx0/PjZEyFah9Eb1QsoDhR5Pe/9kbBOKC87e8qrlD7Ml77cA1Tmy5LmJM//b/vvpPQqmw57m3t3l4t7FO37b6pFblp4Deh8Sqs6upOzdl0wBpJLVl2cHijpGwZG3xO1UFe7sJLImwQUH+XCVyPmtn0CgYB6ZYixs9OilA9C5maWGojRieR373WjE79/cDyIBGyY2j5uncis87fjlMTBuSyOnlMmqVYva9xNAF/055Tt4X9QUNLA50l5Pl0h6giKkOO/ATSavI6F2wEGYU5QQT6w8FfU4kj4PQLtPGt0MOZo0L6cTfYjyzakd4oWjX99i7Rz6wKBgDjpEFAr4FGXGsrZ4h1JqfkbdYW1LaDePUOx8sCuobm2ebj8VJsFnBdY+0Pi5XX/qP/YD5j6W+pmI39ObosAe8+8roPmNocyaX97el03DNPEIh9YvPDNNf8YUCqnZiMY/p36w7MuCAOADKHx+BKuRii0KnFHwheElP/XS86ssgOU
708a4f0b-8b21-4aeb-b64c-e7c7fe19de76	3dc054ae-b43f-4abd-87c5-5d1e63733161	keyUse	enc
64a7c763-336a-4532-87b0-d185b73057c6	3dc054ae-b43f-4abd-87c5-5d1e63733161	certificate	MIICnzCCAYcCBgF84rNd7zANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhNZWRMYWJNUzAeFw0yMTExMDIyMjA3NThaFw0zMTExMDIyMjA5MzhaMBMxETAPBgNVBAMMCE1lZExhYk1TMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm0O0/aEnQweLVYu3GWB/18YY3tWx7axJOxG2UWfbrn4El/Asy/LtNpZQ2o8N3cNCcZlcmOHFiXRXhtLNu3ob1YgtehaERp5gZnD6RYHGRt+2yF3dPpPRgGzWEmKtngxB2Qaa8sTX4GOlMRTRIzEvEOf+jo/c71sjjFoNC8JDTTZtLKbx1sVogqisdbEIPMgFg5HFE9o876h8Sm27J1sbkPF2uDA08AptiJ+hpsWt11kR5vi7zzLAmaSU/gvhlx3MIu/+0D0aR4m3MsQeP884wrF0J5LTFPe3GO/gBYNJIkAGtxIyuxUHYpeoPO3u21kRaAUEwHVSK0mGuqqkUgh5jwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBaDiKUZwdZZL33A7bXJRrM7BbKkzumsmN11Z6/dyPzbHbvhoFt3/v5KSSfshmlp5xINWRVYKgEX43pE+7KzRiuRR1B1ZQYAXVklzeYqU/1+4qHYudP6YvL0mj20mv83LIJEbvjL7SfFfu6R9/6qrMTDFJznJWbqojC8U9ZYCrOYopbZMtHPi15oM0dhucaWPf3itbuc7lWIoIX/P8ggn5BzeRQEdmRF/pC5xlwIqg7ww6rI1qft8DQvrR5ZBdzkdS1FEgFf6/R4scONTvviiGnLRgKSyiLCnwtiXZtdhfGYeaYY5m/5Amr72qMAoeLkGoO8QA+f6pWX6mDdDdLkhoz
4cb80143-b6f1-45a0-bd6c-660940c8a3a4	9d0d7c2f-d807-4247-becc-440efa77df7a	secret	w-pn_suUxpIP0tQf6dxzQDQP2AEpGGYXdIThePL9ja0zDxcuhcRzNcYyTKKfl0ZHqrQpDf_b2MYdmuQ_MXJayg
271eb621-4b23-4971-ac83-fb4c5e1844a9	9d0d7c2f-d807-4247-becc-440efa77df7a	algorithm	HS256
66def41b-4aba-4022-b419-2253a625aa11	9d0d7c2f-d807-4247-becc-440efa77df7a	kid	d4bddaea-25ab-4e5d-9a53-df15fcf06f57
c5dedc27-6a03-428b-922c-efd9033dbe9d	9d0d7c2f-d807-4247-becc-440efa77df7a	priority	100
8b5dbe9b-2695-46a8-8688-30c29ee35292	e9238a6f-dcf1-49a2-83ad-68a8a81d19cf	allow-default-scopes	true
9cd37d38-b8aa-4e1c-859d-15603f852a01	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
74669af8-ea3d-4a35-a0a7-0d98a666a5e2	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
52dec8cb-3d19-4f75-a085-4493b6aa506f	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	saml-role-list-mapper
316ffed0-7e2c-4b97-a7ef-5bc51ba77d22	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
b4e0d3e1-4c06-4a82-ad88-2787ef5de315	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	oidc-full-name-mapper
48af67db-f1d0-43bd-841b-d82ca145f9c4	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	saml-user-attribute-mapper
1112e8c2-c529-47fa-8b79-7c40be3b3de6	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	oidc-address-mapper
10e4c697-d366-4f3e-aefa-a6e768ae245e	0e627819-bcf0-44b9-8d12-6b3025270bb4	allowed-protocol-mapper-types	saml-user-property-mapper
4454e844-4967-4898-a7e3-17618720f3e3	63f8679f-351d-41a4-b650-32f32249b820	allow-default-scopes	true
ea77be66-2019-483e-a6c8-542c5e86221e	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	saml-user-attribute-mapper
3f998ff8-31c0-4d69-a767-01eabe681749	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
48ec12e8-ddc3-40f8-9d4a-7b407ceef03b	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	saml-role-list-mapper
ddb87fa4-acc6-4de7-9219-1cc79a2c6bd0	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
441914a0-2987-4ba4-85a4-6cadaee0c718	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	saml-user-property-mapper
cb8e14fd-520c-4cf6-9c90-66e81b4ee8b5	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
5cd70c02-e90d-4aeb-8bc9-093e7d964bd2	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	oidc-address-mapper
3510ea01-4417-4181-99bb-82bddb077469	7b22f5f1-7f2f-40df-913d-b91ff2c35699	allowed-protocol-mapper-types	oidc-full-name-mapper
f58ae028-1b20-4933-a872-a54f1e6b2fab	e77095d7-e75b-4aa7-a3c4-5dc10b5a341b	max-clients	200
458738e8-6176-44fd-a398-bb1d206b92d6	beadb83a-f598-4e0b-b93a-b615b775a4ab	client-uris-must-match	true
965e518b-49a8-4a62-9f14-cc1c412a6124	beadb83a-f598-4e0b-b93a-b615b775a4ab	host-sending-registration-request-must-match	true
a79b1987-969d-4fe6-83c1-24e107ee7bd6	f378ac31-b9af-4f88-9de7-9c5d82617312	algorithm	HS256
f9356db5-96fc-46e2-a246-09358f94ef6f	f378ac31-b9af-4f88-9de7-9c5d82617312	priority	-100
ef4090d8-cc1a-46d2-b9ca-d47c923d0a20	f378ac31-b9af-4f88-9de7-9c5d82617312	kid	94e29007-1a46-4c3c-8b52-955382612fe9
af567bfb-917d-4a67-8162-3722ae018464	f378ac31-b9af-4f88-9de7-9c5d82617312	secret	5xc285XoaPGl2m5ogVTx8tN6yYvtBJzd1EAvZqs4YlisWU4XD2qkPl-to44rqIFvCXOSzE-HVs4wto9Mv2v52w
93bc6daa-73e7-4a6a-b507-dd352904d3fd	cb73598c-5099-4927-9fba-902324167b6b	certificate	MIICmzCCAYMCBgGJJ/cFzzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjMwNzA1MjEyOTA3WhcNMzMwNzA1MjEzMDQ3WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDW9QKEk5bzjyKQPNhOF+hqjN1FM1MAFAJwlJuPAfrZYWvGPjiqj7QUHBmHMW/BVWLDKTvyMcrd652YH6l0tzGKo8WivyM571i3rmi9QUEg0c+5oWg3Y389RuSA8TMMUeQOP1meSpcWFfB3MWaa/vV46/3iHc6gp0xzHrh0SNq3x5lkMLIWKhqJ8mw788fnEtZsVCZKvszwGyFPUu5RGGFLZZsD95umUc5d/OEwCG8lUXeyfbDjUZdUL3ZlR0C6B65D8hn/PrxhTyyTUrWZcb0hCdg3FgpnD9v/ze8eCqRFeyK3/XRyVXX2FP5Yuphk/4m5D2FirLh5oMpItpnBy/5fAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAKZtJFF6Ybc7C45DGP2DW7+XcZi9zL9Cy3KgZ7vn5Qbb0dBe7iaN7EOpffnDKPvOhSV67Q8ThVgrMTulXg1IKJW6sdryeQFBEJtwRk9/kd+MqWsXtqj7h5uotm/wWqK353VKqbHHtWnU4OQRZR2FHJLzKnEFwiDTkV0A3/LURFTPq85xSuYEuTc4u3tosnTw00HYNibBHIF1de8a4AxqqsnMR4Y9/yS+opYoz0lLSNEmCJWYdGZZ2wtn+junvCYeONaHHGwkpqZSWCgzru5Y6ZIengsQUHt79+TIlGWcupdTuiqXLBVQ9TMcoaX3Kkl/y/UCCvRcEUN+7ZhMmZRL+fw=
d77127bf-7c8e-4c75-b699-0f52bbe8863e	cb73598c-5099-4927-9fba-902324167b6b	algorithm	RS256
277d7b82-00e5-42d7-8c11-e49ba45d025c	cb73598c-5099-4927-9fba-902324167b6b	priority	-100
156c8bf5-5bb7-489d-8541-3540eadcd994	cb73598c-5099-4927-9fba-902324167b6b	privateKey	MIIEpQIBAAKCAQEA1vUChJOW848ikDzYThfoaozdRTNTABQCcJSbjwH62WFrxj44qo+0FBwZhzFvwVViwyk78jHK3eudmB+pdLcxiqPFor8jOe9Yt65ovUFBINHPuaFoN2N/PUbkgPEzDFHkDj9ZnkqXFhXwdzFmmv71eOv94h3OoKdMcx64dEjat8eZZDCyFioaifJsO/PH5xLWbFQmSr7M8BshT1LuURhhS2WbA/ebplHOXfzhMAhvJVF3sn2w41GXVC92ZUdAugeuQ/IZ/z68YU8sk1K1mXG9IQnYNxYKZw/b/83vHgqkRXsit/10clV19hT+WLqYZP+JuQ9hYqy4eaDKSLaZwcv+XwIDAQABAoIBAGnumowNU+G5kzXz1kE+BPqlatIUhf3O3pjuk265cg64tO0gcrqTURJr+qSmV0W2t5In+vPTV/9fgu2aBN+Q/Cgvp1EZ0tlVO6phmBpUUy1CWJVJlttc/DKNgkSNGTQkEzh2PcsFRUnMDBIhVUhjB0PNQPOy7sY7TDCbXhloYekY285v0w29SC5RnTEZhIjHoAHmYRQptsKEQWbi+qinbEXc6PmR3pzPYkc5vP3pBOegxwiIX2vTBotFFcFP1ggpaQt7atlS/p2eMHkjw9kiN/2pkls2ekB4CYS1RnUr/q9+cupwkzHKlGuCc3h2Fj81nXBhK8LVir5h2ro1OPtdOYECgYEA99oIufps635FcII2sBVb2S7iTbQl5Yj41eGdV1Z79Uio6VKVXedgynXAS9R1HGXJRJ00SG3yJqcCKdrUpWbNZUJ8l9k0f1ZCQ3cofjOPJCoxcFWQRudUw7x0HH34b8NgRq8aApFHYmMoHBwRn7zuW7ognwtq3xTdJCA+NwQSK58CgYEA3gYg4xEvroWL1r46MN9Or92usouGlCA9ZVCuAf0bcY6S4irLTftTNxNNA2Eft7nNwbV8Evx3pwiadizbCOZvEtZZ9h9Nw6MWwSZ3plpeFRneJv0r1aipICryb93GWavgS7gTF/Finjz860geA+zw4+I78A1zqYjPFgX5jah5NUECgYEAi5mKCr5rdOSlVe5xwRH2rshCfMO4CKXyif1Osu+qWAh54xk5ui9ljANwsQVUhQ8rovLsjNMobe7pQAvac+MIUz10kc6sTACYyAkojJSbziHZwMzgu572Vl0iBR5KvSCNbKKZgtKzI054PATvREqU8qNOVmaG5mmI+R0UDcbEOT8CgYEAkv+dwJk9Z6BV8M0r+/WtxHTS2LXWWbZqz+y1+O0awXmzOHk6+BuhggKOZ+FjPaKQX2OIjY2IrxfcJMgYEXF4MxGmqHUbaJ9PTnzolUSZrADffBL9dc3ghELLF1PPoslQjPGH+r9AGyKoFiM+dDzpVQgRxSMy5BmHer5j9u2HqsECgYEAoH+tlzJ4etwFhdB0uCR/LsdYL6DJX82kBzqWRxWtzsVAYIizvPzTG8Adj/Dhuy5psL3Cj5BJb7/no9B/A2l6FBbizCeDU5HFql369as/6bBspbWI233UjBbGca2L35rD/IGHFVyorM6ABI9WDcQfHpp68I+842kzj1MkJjh43es=
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
76153201-c763-493b-9e50-881fc285c1cc	951f2371-077f-4fc9-ae48-f8f90e925df2
76153201-c763-493b-9e50-881fc285c1cc	8cc7ddb9-fcc0-42ca-9206-51c744309060
76153201-c763-493b-9e50-881fc285c1cc	d5dc234b-9b85-4dee-aea8-9336acf4100a
76153201-c763-493b-9e50-881fc285c1cc	75a23d8a-cbc6-4024-81a2-b1e492b02bb8
76153201-c763-493b-9e50-881fc285c1cc	94aaeecd-a4fe-4070-8805-26f67ff7c19c
76153201-c763-493b-9e50-881fc285c1cc	d9fba5df-6a08-4d4a-a070-1aa3ee53f6be
76153201-c763-493b-9e50-881fc285c1cc	6ae3dfa8-4bd1-4ecb-b02a-7d07aff01358
76153201-c763-493b-9e50-881fc285c1cc	954412d6-cb03-432e-9558-a6f7619c6fac
76153201-c763-493b-9e50-881fc285c1cc	fd43c898-db97-44d7-ae97-8c478d9059b8
76153201-c763-493b-9e50-881fc285c1cc	c247a813-5fb2-44a9-935f-76ac72c63406
76153201-c763-493b-9e50-881fc285c1cc	9cd8381d-8d6e-4573-a725-6799b12bf87f
76153201-c763-493b-9e50-881fc285c1cc	adbc18fa-848c-4534-9221-f1d9bb76a6e0
76153201-c763-493b-9e50-881fc285c1cc	ce2c2cbc-87a3-48f1-aebd-021e2840b423
76153201-c763-493b-9e50-881fc285c1cc	55fe044a-afc0-4719-8fe3-338222f2b6c9
76153201-c763-493b-9e50-881fc285c1cc	3041e164-344e-45d8-a1cb-a65c1117de6f
76153201-c763-493b-9e50-881fc285c1cc	e4164f64-1dd0-4dac-b523-2a8777c7f9d2
76153201-c763-493b-9e50-881fc285c1cc	dc346db4-a05c-4d6a-b6d7-48bcbd156f0a
76153201-c763-493b-9e50-881fc285c1cc	b85b9cde-7917-41f5-95c3-4475437f62c9
94aaeecd-a4fe-4070-8805-26f67ff7c19c	e4164f64-1dd0-4dac-b523-2a8777c7f9d2
75a23d8a-cbc6-4024-81a2-b1e492b02bb8	3041e164-344e-45d8-a1cb-a65c1117de6f
75a23d8a-cbc6-4024-81a2-b1e492b02bb8	b85b9cde-7917-41f5-95c3-4475437f62c9
3ad939e6-0588-461d-98ea-df431f8c41ef	c14f7fdd-7682-4e75-9a7a-b1ad7de1070c
3ad939e6-0588-461d-98ea-df431f8c41ef	b3358d70-47bc-41c1-a3e2-a6eea1b36a03
b3358d70-47bc-41c1-a3e2-a6eea1b36a03	d272598c-70aa-4f78-a173-17017d8325f9
346d22a3-8716-4fb7-9fb4-2d1228b534fb	b9962576-a8fa-492c-ab91-d1bf15a81c94
76153201-c763-493b-9e50-881fc285c1cc	c5da016c-7d7e-4ff4-9eca-57f7b6caf752
3ad939e6-0588-461d-98ea-df431f8c41ef	48fdff74-2175-4dcf-9edf-073f2fd50cda
3ad939e6-0588-461d-98ea-df431f8c41ef	fc79c197-e293-4b1a-9e39-5d0c196fdeda
76153201-c763-493b-9e50-881fc285c1cc	c9c76129-b559-4b64-bda2-20336f70b7b7
76153201-c763-493b-9e50-881fc285c1cc	6460e328-fa9d-4970-af69-ceb4114dab84
76153201-c763-493b-9e50-881fc285c1cc	036640d5-bdc6-43f1-a851-532779ad15ca
76153201-c763-493b-9e50-881fc285c1cc	e02b7e9e-0701-47ab-a13e-9241ba2fbc33
76153201-c763-493b-9e50-881fc285c1cc	e8f2b092-7f1a-4f07-a460-3951565d185c
76153201-c763-493b-9e50-881fc285c1cc	f3a9097c-b8c3-4bc0-9013-006411a81511
76153201-c763-493b-9e50-881fc285c1cc	12c58d35-5432-4dd5-8782-d0b5b2cc7090
76153201-c763-493b-9e50-881fc285c1cc	ac42471b-c873-4b41-b9fc-ff65d4b89f78
76153201-c763-493b-9e50-881fc285c1cc	b0f8b709-d772-41d2-9af7-273eb95db5bc
76153201-c763-493b-9e50-881fc285c1cc	81da3d35-f5cd-48fa-8d6d-d240e10d455c
76153201-c763-493b-9e50-881fc285c1cc	2b5c0ca1-5f60-4355-9b02-efc32ff4de69
76153201-c763-493b-9e50-881fc285c1cc	c54d0fdc-d72d-47d0-9be2-cee9cc7ef37a
76153201-c763-493b-9e50-881fc285c1cc	7cc541c6-f84f-4ef3-adde-db1ad835cdfe
76153201-c763-493b-9e50-881fc285c1cc	e00d14eb-8863-47f4-8934-4997d7a412a9
76153201-c763-493b-9e50-881fc285c1cc	84f1d0c2-31ea-4efb-a9cb-d776acbd85c3
76153201-c763-493b-9e50-881fc285c1cc	4d224fc4-b0b3-4687-8505-f0db40574d68
76153201-c763-493b-9e50-881fc285c1cc	57d80afd-95c7-482d-8673-dd485d01379e
e02b7e9e-0701-47ab-a13e-9241ba2fbc33	84f1d0c2-31ea-4efb-a9cb-d776acbd85c3
036640d5-bdc6-43f1-a851-532779ad15ca	e00d14eb-8863-47f4-8934-4997d7a412a9
036640d5-bdc6-43f1-a851-532779ad15ca	57d80afd-95c7-482d-8673-dd485d01379e
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	a3191f3b-7a33-473b-8365-4fb40fbc679e
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	42d86a71-ec84-44c1-ad36-5d906640e68d
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	144372cb-18dd-42ad-9f85-be3071e560e3
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	8ebcc056-243e-4b62-930d-2bf1855f71e7
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	adc43523-7c51-4da1-8c35-f3a63d1d494a
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	30389eca-7ac2-45e9-8c4b-041b7b7c6b79
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	f04e2fff-37d5-46ee-8804-d6b82b0a43c7
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	ff7a7e21-c8ee-408d-9ea5-57f902ba7086
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	ac66b3ca-b167-467d-83d2-ec90d0ee4b4c
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	7217ec94-3fe8-40b8-bf7e-ac0732dd9ca1
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	26f71160-804d-4b25-8d7a-20a8c6b2c3e3
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	19bb5251-e102-4caf-8d0a-9454d6bf229a
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	5db76a0a-d5d0-4641-af08-a64fc5b7c502
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	a24c6f36-7c52-4d68-bde2-78aa88e5d418
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	63214fc8-60f0-4f33-a62c-9202f4e10281
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	08be5f1b-e7eb-4384-bb8b-6d116ccfc11d
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	5372828d-1cdc-411f-b959-437e1cb0e824
8ebcc056-243e-4b62-930d-2bf1855f71e7	63214fc8-60f0-4f33-a62c-9202f4e10281
144372cb-18dd-42ad-9f85-be3071e560e3	5372828d-1cdc-411f-b959-437e1cb0e824
144372cb-18dd-42ad-9f85-be3071e560e3	a24c6f36-7c52-4d68-bde2-78aa88e5d418
c323ce56-7ba1-4e9c-b89a-d8a426090013	33cf5c32-3bf0-4b72-b4bd-fb04ea507909
c323ce56-7ba1-4e9c-b89a-d8a426090013	3c5e8ad8-7e3f-4324-8653-a68dd2194870
3c5e8ad8-7e3f-4324-8653-a68dd2194870	21de03e7-a5f2-410e-91e8-c4b0d0da08c5
4e4d0df1-162b-46de-9b1c-b4825760a13e	56833213-3e27-448a-97a9-a2ed592e153b
76153201-c763-493b-9e50-881fc285c1cc	33a6f5d4-4ec5-4b6c-b407-2bb1a6c06cac
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	0b2549ce-9300-4f2c-81da-b3139e300052
c323ce56-7ba1-4e9c-b89a-d8a426090013	75e44024-527f-4375-80f6-6427406420c6
c323ce56-7ba1-4e9c-b89a-d8a426090013	05d38401-7972-4fec-98ea-5b85e3df48eb
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
7bb1f657-d9f8-44c3-8027-9ef48cf16995	\N	password	85785f10-2481-41c1-9508-495d61e3211a	1635890843161	\N	{"value":"O3THrgGsn9WQ6u8LwZ/X3FdGcuH1pmru7Sl5UkTQxtaFS1Ep1b83ckBRnl4I6OGCtAZOtuuCl+NT08V3JVboDA==","salt":"xO52pPVPUrxOvR2ul1c54g==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
3ce83eba-cace-4778-a4e3-62cdb89cad99	\N	password	67d50d0a-b520-481f-a65b-0605021bfda9	1650483993236	\N	{"value":"F1vM3Kg956LbTnSLFeWn83hM92B0GTLAkc8jhbV/gPvJzL4pjH5sNsDbCxvpH7LyqQUU1gkiGkW2LJ7QvI65wQ==","salt":"SAQBXMkOO+rpdHAbYrw3lQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
ad7d5171-f181-4d72-a24f-ebf44c8ac6e2	\N	password	a1bd915e-e4e0-4c1e-b256-f4ba429567f5	1650486792199	\N	{"value":"oaXrQ6dr3hPEorBvDV2XrCyLNauAqAtrn2RaDvkK/6ycLha8bTrNj/a+DWqtQiFjwqjo8euaffu8kjjCpq/UAw==","salt":"D9wkcaKf8KnqsdOX4A84pA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
7db4a8ea-e9b0-467c-ad0a-5338b11566e4	\N	password	406cdfd4-24a1-493b-95e9-7cd4fcb8ae61	1650488140356	\N	{"value":"rnuz81HdjYJ32fCX8BoLhDw+SMkkd/EzI0FjdjPFE+tny4laxo3c718M3YfohCPlSzrWKoBMyL/L/8rX/SEjxA==","salt":"D0UdXUoFGu0do8hElF9omw==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2021-11-02 22:06:02.254511	1	EXECUTED	7:4e70412f24a3f382c82183742ec79317	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	5890761783
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2021-11-02 22:06:02.26691	2	MARK_RAN	7:cb16724583e9675711801c6875114f28	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	5890761783
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2021-11-02 22:06:02.330051	3	EXECUTED	7:0310eb8ba07cec616460794d42ade0fa	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	3.5.4	\N	\N	5890761783
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2021-11-02 22:06:02.333977	4	EXECUTED	7:5d25857e708c3233ef4439df1f93f012	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	5890761783
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2021-11-02 22:06:02.529947	5	EXECUTED	7:c7a54a1041d58eb3817a4a883b4d4e84	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	5890761783
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2021-11-02 22:06:02.53577	6	MARK_RAN	7:2e01012df20974c1c2a605ef8afe25b7	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	5890761783
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2021-11-02 22:06:02.697092	7	EXECUTED	7:0f08df48468428e0f30ee59a8ec01a41	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	5890761783
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2021-11-02 22:06:02.701294	8	MARK_RAN	7:a77ea2ad226b345e7d689d366f185c8c	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	5890761783
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2021-11-02 22:06:02.707498	9	EXECUTED	7:a3377a2059aefbf3b90ebb4c4cc8e2ab	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	3.5.4	\N	\N	5890761783
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2021-11-02 22:06:02.877133	10	EXECUTED	7:04c1dbedc2aa3e9756d1a1668e003451	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	3.5.4	\N	\N	5890761783
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2021-11-02 22:06:02.949218	11	EXECUTED	7:36ef39ed560ad07062d956db861042ba	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	5890761783
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2021-11-02 22:06:02.952701	12	MARK_RAN	7:d909180b2530479a716d3f9c9eaea3d7	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	5890761783
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2021-11-02 22:06:02.968955	13	EXECUTED	7:cf12b04b79bea5152f165eb41f3955f6	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	5890761783
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-11-02 22:06:03.000807	14	EXECUTED	7:7e32c8f05c755e8675764e7d5f514509	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	3.5.4	\N	\N	5890761783
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-11-02 22:06:03.004337	15	MARK_RAN	7:980ba23cc0ec39cab731ce903dd01291	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	5890761783
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-11-02 22:06:03.007318	16	MARK_RAN	7:2fa220758991285312eb84f3b4ff5336	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	3.5.4	\N	\N	5890761783
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-11-02 22:06:03.009355	17	EXECUTED	7:d41d8cd98f00b204e9800998ecf8427e	empty		\N	3.5.4	\N	\N	5890761783
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2021-11-02 22:06:03.083354	18	EXECUTED	7:91ace540896df890cc00a0490ee52bbc	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	3.5.4	\N	\N	5890761783
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2021-11-02 22:06:03.148817	19	EXECUTED	7:c31d1646dfa2618a9335c00e07f89f24	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	5890761783
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2021-11-02 22:06:03.153627	20	EXECUTED	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	5890761783
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-11-02 22:06:04.810297	45	EXECUTED	7:6a48ce645a3525488a90fbf76adf3bb3	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	5890761783
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2021-11-02 22:06:03.156151	21	MARK_RAN	7:f987971fe6b37d963bc95fee2b27f8df	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	5890761783
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2021-11-02 22:06:03.160294	22	MARK_RAN	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	5890761783
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2021-11-02 22:06:03.267501	23	EXECUTED	7:ed2dc7f799d19ac452cbcda56c929e47	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	3.5.4	\N	\N	5890761783
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2021-11-02 22:06:03.272261	24	EXECUTED	7:80b5db88a5dda36ece5f235be8757615	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	5890761783
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2021-11-02 22:06:03.274	25	MARK_RAN	7:1437310ed1305a9b93f8848f301726ce	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	5890761783
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2021-11-02 22:06:03.531455	26	EXECUTED	7:b82ffb34850fa0836be16deefc6a87c4	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	3.5.4	\N	\N	5890761783
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2021-11-02 22:06:03.660538	27	EXECUTED	7:9cc98082921330d8d9266decdd4bd658	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	3.5.4	\N	\N	5890761783
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2021-11-02 22:06:03.665511	28	EXECUTED	7:03d64aeed9cb52b969bd30a7ac0db57e	update tableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	5890761783
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2021-11-02 22:06:03.775411	29	EXECUTED	7:f1f9fd8710399d725b780f463c6b21cd	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	3.5.4	\N	\N	5890761783
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2021-11-02 22:06:03.800318	30	EXECUTED	7:53188c3eb1107546e6f765835705b6c1	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	3.5.4	\N	\N	5890761783
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2021-11-02 22:06:03.822624	31	EXECUTED	7:d6e6f3bc57a0c5586737d1351725d4d4	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	3.5.4	\N	\N	5890761783
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2021-11-02 22:06:03.828556	32	EXECUTED	7:454d604fbd755d9df3fd9c6329043aa5	customChange		\N	3.5.4	\N	\N	5890761783
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-11-02 22:06:03.832575	33	EXECUTED	7:57e98a3077e29caf562f7dbf80c72600	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	5890761783
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-11-02 22:06:03.836723	34	MARK_RAN	7:e4c7e8f2256210aee71ddc42f538b57a	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	5890761783
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-11-02 22:06:03.876715	35	EXECUTED	7:09a43c97e49bc626460480aa1379b522	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	5890761783
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2021-11-02 22:06:03.880727	36	EXECUTED	7:26bfc7c74fefa9126f2ce702fb775553	addColumn tableName=REALM		\N	3.5.4	\N	\N	5890761783
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-11-02 22:06:03.886746	37	EXECUTED	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	5890761783
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2021-11-02 22:06:03.889411	38	EXECUTED	7:37fc1781855ac5388c494f1442b3f717	addColumn tableName=FED_USER_CONSENT		\N	3.5.4	\N	\N	5890761783
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2021-11-02 22:06:03.893434	39	EXECUTED	7:13a27db0dae6049541136adad7261d27	addColumn tableName=IDENTITY_PROVIDER		\N	3.5.4	\N	\N	5890761783
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-11-02 22:06:03.895394	40	MARK_RAN	7:550300617e3b59e8af3a6294df8248a3	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	5890761783
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-11-02 22:06:03.896921	41	MARK_RAN	7:e3a9482b8931481dc2772a5c07c44f17	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	5890761783
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2021-11-02 22:06:03.900963	42	EXECUTED	7:72b07d85a2677cb257edb02b408f332d	customChange		\N	3.5.4	\N	\N	5890761783
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-11-02 22:06:04.798395	43	EXECUTED	7:a72a7858967bd414835d19e04d880312	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	3.5.4	\N	\N	5890761783
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2021-11-02 22:06:04.80479	44	EXECUTED	7:94edff7cf9ce179e7e85f0cd78a3cf2c	addColumn tableName=USER_ENTITY		\N	3.5.4	\N	\N	5890761783
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-11-02 22:06:04.817621	46	EXECUTED	7:e64b5dcea7db06077c6e57d3b9e5ca14	customChange		\N	3.5.4	\N	\N	5890761783
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-11-02 22:06:04.81984	47	MARK_RAN	7:fd8cf02498f8b1e72496a20afc75178c	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	5890761783
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-11-02 22:06:04.954597	48	EXECUTED	7:542794f25aa2b1fbabb7e577d6646319	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	3.5.4	\N	\N	5890761783
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-11-02 22:06:04.959109	49	EXECUTED	7:edad604c882df12f74941dac3cc6d650	addColumn tableName=REALM		\N	3.5.4	\N	\N	5890761783
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2021-11-02 22:06:05.027439	50	EXECUTED	7:0f88b78b7b46480eb92690cbf5e44900	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	3.5.4	\N	\N	5890761783
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2021-11-02 22:06:05.222964	51	EXECUTED	7:d560e43982611d936457c327f872dd59	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	3.5.4	\N	\N	5890761783
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2021-11-02 22:06:05.226305	52	EXECUTED	7:c155566c42b4d14ef07059ec3b3bbd8e	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	5890761783
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2021-11-02 22:06:05.229533	53	EXECUTED	7:b40376581f12d70f3c89ba8ddf5b7dea	update tableName=REALM		\N	3.5.4	\N	\N	5890761783
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2021-11-02 22:06:05.232057	54	EXECUTED	7:a1132cc395f7b95b3646146c2e38f168	update tableName=CLIENT		\N	3.5.4	\N	\N	5890761783
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-11-02 22:06:05.240833	55	EXECUTED	7:d8dc5d89c789105cfa7ca0e82cba60af	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	3.5.4	\N	\N	5890761783
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-11-02 22:06:05.272124	56	EXECUTED	7:7822e0165097182e8f653c35517656a3	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	3.5.4	\N	\N	5890761783
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-11-02 22:06:05.3157	57	EXECUTED	7:c6538c29b9c9a08f9e9ea2de5c2b6375	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	3.5.4	\N	\N	5890761783
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-11-02 22:06:05.64762	58	EXECUTED	7:6d4893e36de22369cf73bcb051ded875	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	3.5.4	\N	\N	5890761783
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2021-11-02 22:06:05.689872	59	EXECUTED	7:57960fc0b0f0dd0563ea6f8b2e4a1707	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	3.5.4	\N	\N	5890761783
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2021-11-02 22:06:05.69751	60	EXECUTED	7:2b4b8bff39944c7097977cc18dbceb3b	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	5890761783
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-11-02 22:06:05.705959	61	EXECUTED	7:2aa42a964c59cd5b8ca9822340ba33a8	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	3.5.4	\N	\N	5890761783
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-11-02 22:06:05.713458	62	EXECUTED	7:9ac9e58545479929ba23f4a3087a0346	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	3.5.4	\N	\N	5890761783
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2021-11-02 22:06:05.717102	63	EXECUTED	7:14d407c35bc4fe1976867756bcea0c36	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	5890761783
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2021-11-02 22:06:05.72058	64	EXECUTED	7:241a8030c748c8548e346adee548fa93	update tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	5890761783
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2021-11-02 22:06:05.723109	65	EXECUTED	7:7d3182f65a34fcc61e8d23def037dc3f	update tableName=RESOURCE_SERVER_RESOURCE		\N	3.5.4	\N	\N	5890761783
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2021-11-02 22:06:05.757512	66	EXECUTED	7:b30039e00a0b9715d430d1b0636728fa	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	3.5.4	\N	\N	5890761783
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2021-11-02 22:06:05.776448	67	EXECUTED	7:3797315ca61d531780f8e6f82f258159	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	3.5.4	\N	\N	5890761783
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2021-11-02 22:06:05.779577	68	EXECUTED	7:c7aa4c8d9573500c2d347c1941ff0301	addColumn tableName=REALM		\N	3.5.4	\N	\N	5890761783
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2021-11-02 22:06:05.800841	69	EXECUTED	7:b207faee394fc074a442ecd42185a5dd	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	3.5.4	\N	\N	5890761783
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2021-11-02 22:06:05.805979	70	EXECUTED	7:ab9a9762faaba4ddfa35514b212c4922	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	3.5.4	\N	\N	5890761783
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2021-11-02 22:06:05.80911	71	EXECUTED	7:b9710f74515a6ccb51b72dc0d19df8c4	addColumn tableName=RESOURCE_SERVER		\N	3.5.4	\N	\N	5890761783
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-11-02 22:06:05.814705	72	EXECUTED	7:ec9707ae4d4f0b7452fee20128083879	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	5890761783
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-11-02 22:06:05.821183	73	EXECUTED	7:3979a0ae07ac465e920ca696532fc736	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	5890761783
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-11-02 22:06:05.823302	74	MARK_RAN	7:5abfde4c259119d143bd2fbf49ac2bca	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	5890761783
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-11-02 22:06:05.880537	75	EXECUTED	7:b48da8c11a3d83ddd6b7d0c8c2219345	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	3.5.4	\N	\N	5890761783
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-11-02 22:06:05.899633	76	EXECUTED	7:a73379915c23bfad3e8f5c6d5c0aa4bd	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	3.5.4	\N	\N	5890761783
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-11-02 22:06:05.902392	77	EXECUTED	7:39e0073779aba192646291aa2332493d	addColumn tableName=CLIENT		\N	3.5.4	\N	\N	5890761783
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-11-02 22:06:05.903903	78	MARK_RAN	7:81f87368f00450799b4bf42ea0b3ec34	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	3.5.4	\N	\N	5890761783
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-11-02 22:06:05.934615	79	EXECUTED	7:20b37422abb9fb6571c618148f013a15	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	3.5.4	\N	\N	5890761783
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-11-02 22:06:05.937099	80	MARK_RAN	7:1970bb6cfb5ee800736b95ad3fb3c78a	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	3.5.4	\N	\N	5890761783
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-11-02 22:06:05.955572	81	EXECUTED	7:45d9b25fc3b455d522d8dcc10a0f4c80	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	3.5.4	\N	\N	5890761783
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-11-02 22:06:05.957367	82	MARK_RAN	7:890ae73712bc187a66c2813a724d037f	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	5890761783
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-11-02 22:06:05.961912	83	EXECUTED	7:0a211980d27fafe3ff50d19a3a29b538	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	5890761783
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-11-02 22:06:05.963351	84	MARK_RAN	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	5890761783
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-11-02 22:06:05.982522	85	EXECUTED	7:01c49302201bdf815b0a18d1f98a55dc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	5890761783
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2021-11-02 22:06:05.9985	86	EXECUTED	7:3dace6b144c11f53f1ad2c0361279b86	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	3.5.4	\N	\N	5890761783
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-11-02 22:06:06.041652	87	EXECUTED	7:578d0b92077eaf2ab95ad0ec087aa903	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	3.5.4	\N	\N	5890761783
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-11-02 22:06:06.055182	88	EXECUTED	7:c95abe90d962c57a09ecaee57972835d	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	3.5.4	\N	\N	5890761783
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.06076	89	EXECUTED	7:f1313bcc2994a5c4dc1062ed6d8282d3	addColumn tableName=REALM; customChange		\N	3.5.4	\N	\N	5890761783
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.110808	90	EXECUTED	7:90d763b52eaffebefbcbde55f269508b	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	3.5.4	\N	\N	5890761783
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.134122	91	EXECUTED	7:d554f0cb92b764470dccfa5e0014a7dd	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	5890761783
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.193441	92	EXECUTED	7:73193e3ab3c35cf0f37ccea3bf783764	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	3.5.4	\N	\N	5890761783
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.195759	93	MARK_RAN	7:90a1e74f92e9cbaa0c5eab80b8a037f3	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	3.5.4	\N	\N	5890761783
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.21514	94	EXECUTED	7:5b9248f29cd047c200083cc6d8388b16	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	3.5.4	\N	\N	5890761783
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.218218	95	MARK_RAN	7:64db59e44c374f13955489e8990d17a1	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	3.5.4	\N	\N	5890761783
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-11-02 22:06:06.224714	96	EXECUTED	7:329a578cdb43262fff975f0a7f6cda60	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	3.5.4	\N	\N	5890761783
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.281103	97	EXECUTED	7:fae0de241ac0fd0bbc2b380b85e4f567	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	5890761783
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.282829	98	MARK_RAN	7:075d54e9180f49bb0c64ca4218936e81	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	5890761783
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.297026	99	MARK_RAN	7:06499836520f4f6b3d05e35a59324910	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	5890761783
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.321497	100	EXECUTED	7:fad08e83c77d0171ec166bc9bc5d390a	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	5890761783
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.323511	101	MARK_RAN	7:3d2b23076e59c6f70bae703aa01be35b	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	5890761783
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.345392	102	EXECUTED	7:1a7f28ff8d9e53aeb879d76ea3d9341a	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	3.5.4	\N	\N	5890761783
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2021-11-02 22:06:06.3496	103	EXECUTED	7:2fd554456fed4a82c698c555c5b751b6	customChange		\N	3.5.4	\N	\N	5890761783
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2021-11-02 22:06:06.355915	104	EXECUTED	7:b06356d66c2790ecc2ae54ba0458397a	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	3.5.4	\N	\N	5890761783
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
master	e3b0d39f-67aa-4233-8930-735a3fc393e8	f
master	a6bd6e2f-ed7b-4e2e-b0ee-cda7652d9843	t
master	fefa0369-b392-4ed7-abc9-3ed0d2c162ea	t
master	8bba7965-1661-4d41-b102-996127f8f36d	t
master	07508c3e-8cc5-4957-98a0-66423972c2ab	f
master	98165bda-fe2e-421f-9041-621095eeb48b	f
master	9fc14758-e341-4d37-9ab7-08a662539828	t
master	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c	t
master	6f681922-b2fc-489b-8569-e29f9280723b	f
MedLabMS	c101cbbe-37da-4aba-a646-20cffd87e257	f
MedLabMS	aad5c8fa-cfd9-4313-9c6b-a001547ad0ec	t
MedLabMS	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1	t
MedLabMS	8cf85305-c87a-42de-bfb7-e71d6fcdde77	t
MedLabMS	fee62b7d-2a34-41de-b29b-6a9bb4465f68	f
MedLabMS	b5866938-46b4-41db-bc1f-910f32a92a7e	f
MedLabMS	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9	t
MedLabMS	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb	t
MedLabMS	c98ee8cd-4148-486c-a90d-39a2668f15b0	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
c696433e-8cc6-4851-9ca2-4155739f8fcb	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
4a58aa39-e242-4e0a-aff9-583b1d68f772	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
6d90f5d1-f359-440f-b295-fdf99d3a66d0	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
b2e69dc4-458f-459f-aaf6-0bdbd38a85db	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
083872c2-e597-4e82-9dba-b84a95faab22	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
68668c32-8465-415c-b954-23b6e0a9078e	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
5c9d49b4-d334-497d-bccd-8c0031703bf3	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
bde2c02c-6d5c-4381-89f0-d88c4357cce2	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
a8a75643-4abf-4215-9d12-66e5f809a69d	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
4311498c-192c-4c00-95eb-25e57d48b005	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
68668c32-8465-415c-b954-23b6e0a9078e	4ff76338-473a-4b7c-869c-94088ac8ed20
16ea080b-518b-407e-a0b2-518a56768ff3	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
c18cdb8d-5bb5-4ddb-8679-04925a518809	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
ed4ee1ae-4dec-4481-91df-8f07bf9b9788	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
ed4ee1ae-4dec-4481-91df-8f07bf9b9788	4ff76338-473a-4b7c-869c-94088ac8ed20
4a58aa39-e242-4e0a-aff9-583b1d68f772	4ff76338-473a-4b7c-869c-94088ac8ed20
5c9d49b4-d334-497d-bccd-8c0031703bf3	4ff76338-473a-4b7c-869c-94088ac8ed20
b62fdccc-ad4a-4d42-aa58-25b062da666c	4ff76338-473a-4b7c-869c-94088ac8ed20
a8a75643-4abf-4215-9d12-66e5f809a69d	4ff76338-473a-4b7c-869c-94088ac8ed20
c18cdb8d-5bb5-4ddb-8679-04925a518809	4ff76338-473a-4b7c-869c-94088ac8ed20
bde2c02c-6d5c-4381-89f0-d88c4357cce2	4ff76338-473a-4b7c-869c-94088ac8ed20
16ea080b-518b-407e-a0b2-518a56768ff3	4ff76338-473a-4b7c-869c-94088ac8ed20
6d90f5d1-f359-440f-b295-fdf99d3a66d0	4ff76338-473a-4b7c-869c-94088ac8ed20
c696433e-8cc6-4851-9ca2-4155739f8fcb	4ff76338-473a-4b7c-869c-94088ac8ed20
b2e69dc4-458f-459f-aaf6-0bdbd38a85db	4ff76338-473a-4b7c-869c-94088ac8ed20
083872c2-e597-4e82-9dba-b84a95faab22	4ff76338-473a-4b7c-869c-94088ac8ed20
4311498c-192c-4c00-95eb-25e57d48b005	4ff76338-473a-4b7c-869c-94088ac8ed20
68668c32-8465-415c-b954-23b6e0a9078e	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
c18cdb8d-5bb5-4ddb-8679-04925a518809	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
bde2c02c-6d5c-4381-89f0-d88c4357cce2	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
6d90f5d1-f359-440f-b295-fdf99d3a66d0	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
c696433e-8cc6-4851-9ca2-4155739f8fcb	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
b2e69dc4-458f-459f-aaf6-0bdbd38a85db	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
083872c2-e597-4e82-9dba-b84a95faab22	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
4311498c-192c-4c00-95eb-25e57d48b005	f9d06b08-8b93-4057-a3ba-ebc3794cf98e
33b72f38-7ef2-49f9-a178-ccb0590c49f8	4ff76338-473a-4b7c-869c-94088ac8ed20
33b72f38-7ef2-49f9-a178-ccb0590c49f8	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
b62fdccc-ad4a-4d42-aa58-25b062da666c	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
4c626ae4-ce79-4a89-9c78-69cf34f127f0	d15ed60f-6d5d-4aef-b227-e31ccdee0a1b
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
d15ed60f-6d5d-4aef-b227-e31ccdee0a1b	Test1	 	MedLabMS
4ff76338-473a-4b7c-869c-94088ac8ed20	Admin1	 	MedLabMS
f9d06b08-8b93-4057-a3ba-ebc3794cf98e	Admin2	 	MedLabMS
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
3ad939e6-0588-461d-98ea-df431f8c41ef	master	f	${role_default-roles}	default-roles-master	master	\N	\N
76153201-c763-493b-9e50-881fc285c1cc	master	f	${role_admin}	admin	master	\N	\N
951f2371-077f-4fc9-ae48-f8f90e925df2	master	f	${role_create-realm}	create-realm	master	\N	\N
8cc7ddb9-fcc0-42ca-9206-51c744309060	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_create-client}	create-client	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
d5dc234b-9b85-4dee-aea8-9336acf4100a	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_view-realm}	view-realm	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
75a23d8a-cbc6-4024-81a2-b1e492b02bb8	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_view-users}	view-users	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
94aaeecd-a4fe-4070-8805-26f67ff7c19c	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_view-clients}	view-clients	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
d9fba5df-6a08-4d4a-a070-1aa3ee53f6be	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_view-events}	view-events	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
6ae3dfa8-4bd1-4ecb-b02a-7d07aff01358	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_view-identity-providers}	view-identity-providers	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
954412d6-cb03-432e-9558-a6f7619c6fac	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_view-authorization}	view-authorization	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
fd43c898-db97-44d7-ae97-8c478d9059b8	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_manage-realm}	manage-realm	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
c247a813-5fb2-44a9-935f-76ac72c63406	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_manage-users}	manage-users	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
9cd8381d-8d6e-4573-a725-6799b12bf87f	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_manage-clients}	manage-clients	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
adbc18fa-848c-4534-9221-f1d9bb76a6e0	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_manage-events}	manage-events	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
ce2c2cbc-87a3-48f1-aebd-021e2840b423	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_manage-identity-providers}	manage-identity-providers	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
55fe044a-afc0-4719-8fe3-338222f2b6c9	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_manage-authorization}	manage-authorization	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
3041e164-344e-45d8-a1cb-a65c1117de6f	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_query-users}	query-users	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
e4164f64-1dd0-4dac-b523-2a8777c7f9d2	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_query-clients}	query-clients	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
dc346db4-a05c-4d6a-b6d7-48bcbd156f0a	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_query-realms}	query-realms	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
b85b9cde-7917-41f5-95c3-4475437f62c9	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_query-groups}	query-groups	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
c14f7fdd-7682-4e75-9a7a-b1ad7de1070c	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_view-profile}	view-profile	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
b3358d70-47bc-41c1-a3e2-a6eea1b36a03	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_manage-account}	manage-account	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
d272598c-70aa-4f78-a173-17017d8325f9	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_manage-account-links}	manage-account-links	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
9ff10213-cb24-4e27-ad4f-b8b67dfc4740	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_view-applications}	view-applications	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
b9962576-a8fa-492c-ab91-d1bf15a81c94	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_view-consent}	view-consent	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
346d22a3-8716-4fb7-9fb4-2d1228b534fb	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_manage-consent}	manage-consent	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
861fb3d9-96da-4b9c-ae53-ab5cd3c43704	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	t	${role_delete-account}	delete-account	master	9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	\N
e36cd710-ffda-469d-8664-c58b589a9ec7	c8751636-5463-4262-b11f-5d79831d4ac0	t	${role_read-token}	read-token	master	c8751636-5463-4262-b11f-5d79831d4ac0	\N
c5da016c-7d7e-4ff4-9eca-57f7b6caf752	b912181c-b693-4335-a0bd-e4a7e4e5811d	t	${role_impersonation}	impersonation	master	b912181c-b693-4335-a0bd-e4a7e4e5811d	\N
48fdff74-2175-4dcf-9edf-073f2fd50cda	master	f	${role_offline-access}	offline_access	master	\N	\N
fc79c197-e293-4b1a-9e39-5d0c196fdeda	master	f	${role_uma_authorization}	uma_authorization	master	\N	\N
c323ce56-7ba1-4e9c-b89a-d8a426090013	MedLabMS	f	${role_default-roles}	default-roles-medlabms	MedLabMS	\N	\N
c9c76129-b559-4b64-bda2-20336f70b7b7	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_create-client}	create-client	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
6460e328-fa9d-4970-af69-ceb4114dab84	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_view-realm}	view-realm	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
036640d5-bdc6-43f1-a851-532779ad15ca	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_view-users}	view-users	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
e02b7e9e-0701-47ab-a13e-9241ba2fbc33	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_view-clients}	view-clients	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
e8f2b092-7f1a-4f07-a460-3951565d185c	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_view-events}	view-events	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
f3a9097c-b8c3-4bc0-9013-006411a81511	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_view-identity-providers}	view-identity-providers	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
12c58d35-5432-4dd5-8782-d0b5b2cc7090	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_view-authorization}	view-authorization	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
ac42471b-c873-4b41-b9fc-ff65d4b89f78	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_manage-realm}	manage-realm	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
b0f8b709-d772-41d2-9af7-273eb95db5bc	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_manage-users}	manage-users	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
81da3d35-f5cd-48fa-8d6d-d240e10d455c	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_manage-clients}	manage-clients	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
2b5c0ca1-5f60-4355-9b02-efc32ff4de69	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_manage-events}	manage-events	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
c54d0fdc-d72d-47d0-9be2-cee9cc7ef37a	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_manage-identity-providers}	manage-identity-providers	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
7cc541c6-f84f-4ef3-adde-db1ad835cdfe	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_manage-authorization}	manage-authorization	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
e00d14eb-8863-47f4-8934-4997d7a412a9	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_query-users}	query-users	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
84f1d0c2-31ea-4efb-a9cb-d776acbd85c3	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_query-clients}	query-clients	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
4d224fc4-b0b3-4687-8505-f0db40574d68	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_query-realms}	query-realms	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
57d80afd-95c7-482d-8673-dd485d01379e	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_query-groups}	query-groups	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
4dcc87c0-6882-4a88-83ae-f3c0cb9ec464	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_realm-admin}	realm-admin	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
a3191f3b-7a33-473b-8365-4fb40fbc679e	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_create-client}	create-client	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
42d86a71-ec84-44c1-ad36-5d906640e68d	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_view-realm}	view-realm	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
144372cb-18dd-42ad-9f85-be3071e560e3	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_view-users}	view-users	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
8ebcc056-243e-4b62-930d-2bf1855f71e7	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_view-clients}	view-clients	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
adc43523-7c51-4da1-8c35-f3a63d1d494a	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_view-events}	view-events	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
30389eca-7ac2-45e9-8c4b-041b7b7c6b79	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_view-identity-providers}	view-identity-providers	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
f04e2fff-37d5-46ee-8804-d6b82b0a43c7	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_view-authorization}	view-authorization	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
ff7a7e21-c8ee-408d-9ea5-57f902ba7086	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_manage-realm}	manage-realm	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
ac66b3ca-b167-467d-83d2-ec90d0ee4b4c	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_manage-users}	manage-users	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
7217ec94-3fe8-40b8-bf7e-ac0732dd9ca1	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_manage-clients}	manage-clients	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
26f71160-804d-4b25-8d7a-20a8c6b2c3e3	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_manage-events}	manage-events	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
19bb5251-e102-4caf-8d0a-9454d6bf229a	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_manage-identity-providers}	manage-identity-providers	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
5db76a0a-d5d0-4641-af08-a64fc5b7c502	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_manage-authorization}	manage-authorization	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
a24c6f36-7c52-4d68-bde2-78aa88e5d418	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_query-users}	query-users	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
63214fc8-60f0-4f33-a62c-9202f4e10281	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_query-clients}	query-clients	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
08be5f1b-e7eb-4384-bb8b-6d116ccfc11d	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_query-realms}	query-realms	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
5372828d-1cdc-411f-b959-437e1cb0e824	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_query-groups}	query-groups	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
33cf5c32-3bf0-4b72-b4bd-fb04ea507909	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_view-profile}	view-profile	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
3c5e8ad8-7e3f-4324-8653-a68dd2194870	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_manage-account}	manage-account	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
21de03e7-a5f2-410e-91e8-c4b0d0da08c5	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_manage-account-links}	manage-account-links	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
1013aa9c-8e86-4729-a13e-6c8e35556992	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_view-applications}	view-applications	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
56833213-3e27-448a-97a9-a2ed592e153b	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_view-consent}	view-consent	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
4e4d0df1-162b-46de-9b1c-b4825760a13e	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_manage-consent}	manage-consent	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
5ed4cc92-7f87-4bb9-aa66-19f08a432ad3	709f81e4-9774-4ad5-9aa9-723903b1c90a	t	${role_delete-account}	delete-account	MedLabMS	709f81e4-9774-4ad5-9aa9-723903b1c90a	\N
33a6f5d4-4ec5-4b6c-b407-2bb1a6c06cac	71250ec0-20be-40e0-b7c1-d07906469908	t	${role_impersonation}	impersonation	master	71250ec0-20be-40e0-b7c1-d07906469908	\N
0b2549ce-9300-4f2c-81da-b3139e300052	0d8a4179-d49a-412d-866c-7d920925bb4a	t	${role_impersonation}	impersonation	MedLabMS	0d8a4179-d49a-412d-866c-7d920925bb4a	\N
56bab725-a2b8-40e6-a7eb-b6270e32f11c	b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	t	${role_read-token}	read-token	MedLabMS	b5e6483e-ac84-41b7-99c9-3f2139e4c1d2	\N
75e44024-527f-4375-80f6-6427406420c6	MedLabMS	f	${role_offline-access}	offline_access	MedLabMS	\N	\N
05d38401-7972-4fec-98ea-5b85e3df48eb	MedLabMS	f	${role_uma_authorization}	uma_authorization	MedLabMS	\N	\N
68668c32-8465-415c-b954-23b6e0a9078e	MedLabMS	f	Read patients role	patients:read	MedLabMS	\N	\N
4311498c-192c-4c00-95eb-25e57d48b005	MedLabMS	f	Role to read users	users:read	MedLabMS	\N	\N
16ea080b-518b-407e-a0b2-518a56768ff3	MedLabMS	f	Role to save users	users:save	MedLabMS	\N	\N
c18cdb8d-5bb5-4ddb-8679-04925a518809	MedLabMS	f	Role to read groups	groups:read	MedLabMS	\N	\N
ed4ee1ae-4dec-4481-91df-8f07bf9b9788	MedLabMS	f	Role to save groups	groups:save	MedLabMS	\N	\N
b62fdccc-ad4a-4d42-aa58-25b062da666c	MedLabMS	f	Role to save patients	patients:save	MedLabMS	\N	\N
6d90f5d1-f359-440f-b295-fdf99d3a66d0	MedLabMS	f	Role to read analyses groups	analysesGroups:read	MedLabMS	\N	\N
b2e69dc4-458f-459f-aaf6-0bdbd38a85db	MedLabMS	f	Role to save analyses groups	analysesGroups:save	MedLabMS	\N	\N
c696433e-8cc6-4851-9ca2-4155739f8fcb	MedLabMS	f	Role to read analyses	analyses:read	MedLabMS	\N	\N
4a58aa39-e242-4e0a-aff9-583b1d68f772	MedLabMS	f	Role to save analyses	analyses:save	MedLabMS	\N	\N
083872c2-e597-4e82-9dba-b84a95faab22	MedLabMS	f	Role to read metrics	metrics:read	MedLabMS	\N	\N
5c9d49b4-d334-497d-bccd-8c0031703bf3	MedLabMS	f	Role to save metrics	metrics:save	MedLabMS	\N	\N
bde2c02c-6d5c-4381-89f0-d88c4357cce2	MedLabMS	f	Role to read visits	visits:read	MedLabMS	\N	\N
a8a75643-4abf-4215-9d12-66e5f809a69d	MedLabMS	f	Role to save visits	visits:save	MedLabMS	\N	\N
33b72f38-7ef2-49f9-a178-ccb0590c49f8	MedLabMS	f	Role to manage user itself	self:save	MedLabMS	\N	\N
4c626ae4-ce79-4a89-9c78-69cf34f127f0	MedLabMS	f	Role to read audits	audits:read	MedLabMS	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
skykp	15.0.2	1635890769
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
ef60454a-e115-4327-ba7d-cac04efe9a30	audience resolve	openid-connect	oidc-audience-resolve-mapper	dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	\N
3827f22f-c474-4e4b-81d1-a87fd3328e26	locale	openid-connect	oidc-usermodel-attribute-mapper	5279cdb1-a17d-4ab8-a091-8e909ee0d898	\N
0e64df75-dcce-4e39-8d27-63c10980a84a	role list	saml	saml-role-list-mapper	\N	a6bd6e2f-ed7b-4e2e-b0ee-cda7652d9843
ca9c2e55-0eb5-426d-a2ff-09119c450e1f	full name	openid-connect	oidc-full-name-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
b251af29-9c3f-459d-b331-e8cbaf81756d	family name	openid-connect	oidc-usermodel-property-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
ac93a40f-6ba1-47d7-9e36-295e6929e93d	given name	openid-connect	oidc-usermodel-property-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
4934cb0c-aabd-42e8-906e-1bbf750de1c5	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
90da742d-d3a3-49ca-a461-bfb590a8c241	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
8f3cdf68-113d-4886-b3e2-646d8ddd0680	username	openid-connect	oidc-usermodel-property-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
0d38b8cd-88d2-4b8b-b001-334a29f672c1	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	website	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
6ecee6ce-02c6-459f-a9ca-43c204d95514	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
4840ad1f-85e5-4873-8d2a-eb1026cd425c	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
33ea9dd1-6de7-48da-b06e-1a792916c5f2	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
af64c536-2867-45b9-a309-cf99c0aed73a	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
b2e074a4-ab2f-4bd8-962e-925ad22404ed	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	fefa0369-b392-4ed7-abc9-3ed0d2c162ea
634e5f1b-3f6f-4220-a733-aea7b6e44c78	email	openid-connect	oidc-usermodel-property-mapper	\N	8bba7965-1661-4d41-b102-996127f8f36d
acc29a2f-b549-4511-addc-6bd44e7c5d7f	email verified	openid-connect	oidc-usermodel-property-mapper	\N	8bba7965-1661-4d41-b102-996127f8f36d
e53651e4-ce33-442c-857d-cdcc82ab3305	address	openid-connect	oidc-address-mapper	\N	07508c3e-8cc5-4957-98a0-66423972c2ab
de9feea8-b097-428e-b9e8-bd39c5020f39	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	98165bda-fe2e-421f-9041-621095eeb48b
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	98165bda-fe2e-421f-9041-621095eeb48b
f4434dc5-d2e2-4e75-b32f-98993550ac19	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	9fc14758-e341-4d37-9ab7-08a662539828
66085688-5f08-440d-a035-be86bf9051f9	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	9fc14758-e341-4d37-9ab7-08a662539828
9b70e69c-c160-4d00-9264-bdc93fb80983	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	9fc14758-e341-4d37-9ab7-08a662539828
3a99a4b0-0953-4f3b-a9d0-a4f3ba9d8d75	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	4f9fb403-2ae6-4ae5-aa82-11b261cd1c4c
098eefa8-da78-4421-b3ec-20f648d264c7	upn	openid-connect	oidc-usermodel-property-mapper	\N	6f681922-b2fc-489b-8569-e29f9280723b
e95719ff-1a0e-493e-8b43-58902a75c803	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	6f681922-b2fc-489b-8569-e29f9280723b
58ef0293-41f3-4dd9-a23f-63bad1f4fd1f	audience resolve	openid-connect	oidc-audience-resolve-mapper	9faaf662-da17-4f1c-91c8-e6cfb0794eef	\N
95c3017d-6c88-48e2-8494-cc19d842d6fe	role list	saml	saml-role-list-mapper	\N	aad5c8fa-cfd9-4313-9c6b-a001547ad0ec
cc707c33-8406-4061-9676-ca15195268a1	full name	openid-connect	oidc-full-name-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	family name	openid-connect	oidc-usermodel-property-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
2428ee98-8acc-44d8-8951-2e8643875052	given name	openid-connect	oidc-usermodel-property-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
b40f98fe-3965-4bbc-9846-3811431a37ee	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
c7ab5023-56c4-4602-a11f-6b17d5e089bb	username	openid-connect	oidc-usermodel-property-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
1c181240-6626-40a5-9a77-8f11f45e49f6	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
58519ba1-9ca6-46a8-9c11-89c67621f5cf	website	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
cf6179b9-74b5-4a8e-96b5-b6b55994a212	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
2c7bc770-1ed8-4818-b494-590b17832442	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
19c862c8-bd13-44ad-b861-292b7207e5dd	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	18a9a0fc-33f2-40ac-b0ba-3df98231f3d1
3780dc8b-6c36-4950-bd8e-553513effcbc	email	openid-connect	oidc-usermodel-property-mapper	\N	8cf85305-c87a-42de-bfb7-e71d6fcdde77
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	email verified	openid-connect	oidc-usermodel-property-mapper	\N	8cf85305-c87a-42de-bfb7-e71d6fcdde77
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	address	openid-connect	oidc-address-mapper	\N	fee62b7d-2a34-41de-b29b-6a9bb4465f68
5b5e46e0-ae25-4850-82e2-dd93484d120d	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	b5866938-46b4-41db-bc1f-910f32a92a7e
052fee33-c01f-4988-b1cd-156ddaccfbf6	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	b5866938-46b4-41db-bc1f-910f32a92a7e
0084b45b-bf21-49fe-8a17-2f167ec28c09	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9
2a58768f-0dec-4473-bfed-44bcf66bc178	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9
a1cf98ee-dccc-4fa6-89af-1fe66b022d81	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	943e7dd2-320e-4509-9e0d-0c8fd51ff8f9
b17a3ef8-9cbf-4635-9af6-005af08c66d9	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	c9e5fe3a-0cd1-4321-935a-e8bb5a4fc4fb
01553be7-139c-4239-982b-710d2ebc4844	upn	openid-connect	oidc-usermodel-property-mapper	\N	c98ee8cd-4148-486c-a90d-39a2668f15b0
bca85f32-1686-4a0c-863c-4b5ed3d17483	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	c98ee8cd-4148-486c-a90d-39a2668f15b0
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	locale	openid-connect	oidc-usermodel-attribute-mapper	a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	\N
6125cfd1-f524-4478-9e92-c96f75eb31e8	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	3ec008e8-b299-41da-a7e7-863e71dbc181	\N
5df89693-273b-4466-ab5b-a543942c9b08	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	3ec008e8-b299-41da-a7e7-863e71dbc181	\N
a7537049-c4a8-41fa-95ab-e42ffaa4d93e	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	3ec008e8-b299-41da-a7e7-863e71dbc181	\N
6c880427-ccaa-4708-8fb1-8438e568a762	roles	openid-connect	oidc-usermodel-realm-role-mapper	50aab8c6-991d-4294-9b59-d9d59426ce08	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
3827f22f-c474-4e4b-81d1-a87fd3328e26	true	userinfo.token.claim
3827f22f-c474-4e4b-81d1-a87fd3328e26	locale	user.attribute
3827f22f-c474-4e4b-81d1-a87fd3328e26	true	id.token.claim
3827f22f-c474-4e4b-81d1-a87fd3328e26	true	access.token.claim
3827f22f-c474-4e4b-81d1-a87fd3328e26	locale	claim.name
3827f22f-c474-4e4b-81d1-a87fd3328e26	String	jsonType.label
0e64df75-dcce-4e39-8d27-63c10980a84a	false	single
0e64df75-dcce-4e39-8d27-63c10980a84a	Basic	attribute.nameformat
0e64df75-dcce-4e39-8d27-63c10980a84a	Role	attribute.name
ca9c2e55-0eb5-426d-a2ff-09119c450e1f	true	userinfo.token.claim
ca9c2e55-0eb5-426d-a2ff-09119c450e1f	true	id.token.claim
ca9c2e55-0eb5-426d-a2ff-09119c450e1f	true	access.token.claim
b251af29-9c3f-459d-b331-e8cbaf81756d	true	userinfo.token.claim
b251af29-9c3f-459d-b331-e8cbaf81756d	lastName	user.attribute
b251af29-9c3f-459d-b331-e8cbaf81756d	true	id.token.claim
b251af29-9c3f-459d-b331-e8cbaf81756d	true	access.token.claim
b251af29-9c3f-459d-b331-e8cbaf81756d	family_name	claim.name
b251af29-9c3f-459d-b331-e8cbaf81756d	String	jsonType.label
ac93a40f-6ba1-47d7-9e36-295e6929e93d	true	userinfo.token.claim
ac93a40f-6ba1-47d7-9e36-295e6929e93d	firstName	user.attribute
ac93a40f-6ba1-47d7-9e36-295e6929e93d	true	id.token.claim
ac93a40f-6ba1-47d7-9e36-295e6929e93d	true	access.token.claim
ac93a40f-6ba1-47d7-9e36-295e6929e93d	given_name	claim.name
ac93a40f-6ba1-47d7-9e36-295e6929e93d	String	jsonType.label
4934cb0c-aabd-42e8-906e-1bbf750de1c5	true	userinfo.token.claim
4934cb0c-aabd-42e8-906e-1bbf750de1c5	middleName	user.attribute
4934cb0c-aabd-42e8-906e-1bbf750de1c5	true	id.token.claim
4934cb0c-aabd-42e8-906e-1bbf750de1c5	true	access.token.claim
4934cb0c-aabd-42e8-906e-1bbf750de1c5	middle_name	claim.name
4934cb0c-aabd-42e8-906e-1bbf750de1c5	String	jsonType.label
90da742d-d3a3-49ca-a461-bfb590a8c241	true	userinfo.token.claim
90da742d-d3a3-49ca-a461-bfb590a8c241	nickname	user.attribute
90da742d-d3a3-49ca-a461-bfb590a8c241	true	id.token.claim
90da742d-d3a3-49ca-a461-bfb590a8c241	true	access.token.claim
90da742d-d3a3-49ca-a461-bfb590a8c241	nickname	claim.name
90da742d-d3a3-49ca-a461-bfb590a8c241	String	jsonType.label
8f3cdf68-113d-4886-b3e2-646d8ddd0680	true	userinfo.token.claim
8f3cdf68-113d-4886-b3e2-646d8ddd0680	username	user.attribute
8f3cdf68-113d-4886-b3e2-646d8ddd0680	true	id.token.claim
8f3cdf68-113d-4886-b3e2-646d8ddd0680	true	access.token.claim
8f3cdf68-113d-4886-b3e2-646d8ddd0680	preferred_username	claim.name
8f3cdf68-113d-4886-b3e2-646d8ddd0680	String	jsonType.label
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	true	userinfo.token.claim
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	profile	user.attribute
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	true	id.token.claim
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	true	access.token.claim
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	profile	claim.name
b2df5bc1-4cda-4a34-a863-8b0a9fb1a04e	String	jsonType.label
0d38b8cd-88d2-4b8b-b001-334a29f672c1	true	userinfo.token.claim
0d38b8cd-88d2-4b8b-b001-334a29f672c1	picture	user.attribute
0d38b8cd-88d2-4b8b-b001-334a29f672c1	true	id.token.claim
0d38b8cd-88d2-4b8b-b001-334a29f672c1	true	access.token.claim
0d38b8cd-88d2-4b8b-b001-334a29f672c1	picture	claim.name
0d38b8cd-88d2-4b8b-b001-334a29f672c1	String	jsonType.label
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	true	userinfo.token.claim
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	website	user.attribute
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	true	id.token.claim
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	true	access.token.claim
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	website	claim.name
f0287716-80fc-44f4-8c95-7ba3f0d82a1a	String	jsonType.label
6ecee6ce-02c6-459f-a9ca-43c204d95514	true	userinfo.token.claim
6ecee6ce-02c6-459f-a9ca-43c204d95514	gender	user.attribute
6ecee6ce-02c6-459f-a9ca-43c204d95514	true	id.token.claim
6ecee6ce-02c6-459f-a9ca-43c204d95514	true	access.token.claim
6ecee6ce-02c6-459f-a9ca-43c204d95514	gender	claim.name
6ecee6ce-02c6-459f-a9ca-43c204d95514	String	jsonType.label
4840ad1f-85e5-4873-8d2a-eb1026cd425c	true	userinfo.token.claim
4840ad1f-85e5-4873-8d2a-eb1026cd425c	birthdate	user.attribute
4840ad1f-85e5-4873-8d2a-eb1026cd425c	true	id.token.claim
4840ad1f-85e5-4873-8d2a-eb1026cd425c	true	access.token.claim
4840ad1f-85e5-4873-8d2a-eb1026cd425c	birthdate	claim.name
4840ad1f-85e5-4873-8d2a-eb1026cd425c	String	jsonType.label
33ea9dd1-6de7-48da-b06e-1a792916c5f2	true	userinfo.token.claim
33ea9dd1-6de7-48da-b06e-1a792916c5f2	zoneinfo	user.attribute
33ea9dd1-6de7-48da-b06e-1a792916c5f2	true	id.token.claim
33ea9dd1-6de7-48da-b06e-1a792916c5f2	true	access.token.claim
33ea9dd1-6de7-48da-b06e-1a792916c5f2	zoneinfo	claim.name
33ea9dd1-6de7-48da-b06e-1a792916c5f2	String	jsonType.label
af64c536-2867-45b9-a309-cf99c0aed73a	true	userinfo.token.claim
af64c536-2867-45b9-a309-cf99c0aed73a	locale	user.attribute
af64c536-2867-45b9-a309-cf99c0aed73a	true	id.token.claim
af64c536-2867-45b9-a309-cf99c0aed73a	true	access.token.claim
af64c536-2867-45b9-a309-cf99c0aed73a	locale	claim.name
af64c536-2867-45b9-a309-cf99c0aed73a	String	jsonType.label
b2e074a4-ab2f-4bd8-962e-925ad22404ed	true	userinfo.token.claim
b2e074a4-ab2f-4bd8-962e-925ad22404ed	updatedAt	user.attribute
b2e074a4-ab2f-4bd8-962e-925ad22404ed	true	id.token.claim
b2e074a4-ab2f-4bd8-962e-925ad22404ed	true	access.token.claim
b2e074a4-ab2f-4bd8-962e-925ad22404ed	updated_at	claim.name
b2e074a4-ab2f-4bd8-962e-925ad22404ed	String	jsonType.label
634e5f1b-3f6f-4220-a733-aea7b6e44c78	true	userinfo.token.claim
634e5f1b-3f6f-4220-a733-aea7b6e44c78	email	user.attribute
634e5f1b-3f6f-4220-a733-aea7b6e44c78	true	id.token.claim
634e5f1b-3f6f-4220-a733-aea7b6e44c78	true	access.token.claim
634e5f1b-3f6f-4220-a733-aea7b6e44c78	email	claim.name
634e5f1b-3f6f-4220-a733-aea7b6e44c78	String	jsonType.label
acc29a2f-b549-4511-addc-6bd44e7c5d7f	true	userinfo.token.claim
acc29a2f-b549-4511-addc-6bd44e7c5d7f	emailVerified	user.attribute
acc29a2f-b549-4511-addc-6bd44e7c5d7f	true	id.token.claim
acc29a2f-b549-4511-addc-6bd44e7c5d7f	true	access.token.claim
acc29a2f-b549-4511-addc-6bd44e7c5d7f	email_verified	claim.name
acc29a2f-b549-4511-addc-6bd44e7c5d7f	boolean	jsonType.label
e53651e4-ce33-442c-857d-cdcc82ab3305	formatted	user.attribute.formatted
e53651e4-ce33-442c-857d-cdcc82ab3305	country	user.attribute.country
e53651e4-ce33-442c-857d-cdcc82ab3305	postal_code	user.attribute.postal_code
e53651e4-ce33-442c-857d-cdcc82ab3305	true	userinfo.token.claim
e53651e4-ce33-442c-857d-cdcc82ab3305	street	user.attribute.street
e53651e4-ce33-442c-857d-cdcc82ab3305	true	id.token.claim
e53651e4-ce33-442c-857d-cdcc82ab3305	region	user.attribute.region
e53651e4-ce33-442c-857d-cdcc82ab3305	true	access.token.claim
e53651e4-ce33-442c-857d-cdcc82ab3305	locality	user.attribute.locality
de9feea8-b097-428e-b9e8-bd39c5020f39	true	userinfo.token.claim
de9feea8-b097-428e-b9e8-bd39c5020f39	phoneNumber	user.attribute
de9feea8-b097-428e-b9e8-bd39c5020f39	true	id.token.claim
de9feea8-b097-428e-b9e8-bd39c5020f39	true	access.token.claim
de9feea8-b097-428e-b9e8-bd39c5020f39	phone_number	claim.name
de9feea8-b097-428e-b9e8-bd39c5020f39	String	jsonType.label
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	true	userinfo.token.claim
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	phoneNumberVerified	user.attribute
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	true	id.token.claim
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	true	access.token.claim
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	phone_number_verified	claim.name
32b57b7f-55d8-4aaf-a6dd-b881bce42c87	boolean	jsonType.label
f4434dc5-d2e2-4e75-b32f-98993550ac19	true	multivalued
f4434dc5-d2e2-4e75-b32f-98993550ac19	foo	user.attribute
f4434dc5-d2e2-4e75-b32f-98993550ac19	true	access.token.claim
f4434dc5-d2e2-4e75-b32f-98993550ac19	realm_access.roles	claim.name
f4434dc5-d2e2-4e75-b32f-98993550ac19	String	jsonType.label
66085688-5f08-440d-a035-be86bf9051f9	true	multivalued
66085688-5f08-440d-a035-be86bf9051f9	foo	user.attribute
66085688-5f08-440d-a035-be86bf9051f9	true	access.token.claim
66085688-5f08-440d-a035-be86bf9051f9	resource_access.${client_id}.roles	claim.name
66085688-5f08-440d-a035-be86bf9051f9	String	jsonType.label
098eefa8-da78-4421-b3ec-20f648d264c7	true	userinfo.token.claim
098eefa8-da78-4421-b3ec-20f648d264c7	username	user.attribute
098eefa8-da78-4421-b3ec-20f648d264c7	true	id.token.claim
098eefa8-da78-4421-b3ec-20f648d264c7	true	access.token.claim
098eefa8-da78-4421-b3ec-20f648d264c7	upn	claim.name
098eefa8-da78-4421-b3ec-20f648d264c7	String	jsonType.label
e95719ff-1a0e-493e-8b43-58902a75c803	true	multivalued
e95719ff-1a0e-493e-8b43-58902a75c803	foo	user.attribute
e95719ff-1a0e-493e-8b43-58902a75c803	true	id.token.claim
e95719ff-1a0e-493e-8b43-58902a75c803	true	access.token.claim
e95719ff-1a0e-493e-8b43-58902a75c803	groups	claim.name
e95719ff-1a0e-493e-8b43-58902a75c803	String	jsonType.label
95c3017d-6c88-48e2-8494-cc19d842d6fe	false	single
95c3017d-6c88-48e2-8494-cc19d842d6fe	Basic	attribute.nameformat
95c3017d-6c88-48e2-8494-cc19d842d6fe	Role	attribute.name
cc707c33-8406-4061-9676-ca15195268a1	true	userinfo.token.claim
cc707c33-8406-4061-9676-ca15195268a1	true	id.token.claim
cc707c33-8406-4061-9676-ca15195268a1	true	access.token.claim
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	true	userinfo.token.claim
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	lastName	user.attribute
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	true	id.token.claim
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	true	access.token.claim
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	family_name	claim.name
93d8b760-08e3-4b0f-b5c7-ea32a5a81094	String	jsonType.label
2428ee98-8acc-44d8-8951-2e8643875052	true	userinfo.token.claim
2428ee98-8acc-44d8-8951-2e8643875052	firstName	user.attribute
2428ee98-8acc-44d8-8951-2e8643875052	true	id.token.claim
2428ee98-8acc-44d8-8951-2e8643875052	true	access.token.claim
2428ee98-8acc-44d8-8951-2e8643875052	given_name	claim.name
2428ee98-8acc-44d8-8951-2e8643875052	String	jsonType.label
b40f98fe-3965-4bbc-9846-3811431a37ee	true	userinfo.token.claim
b40f98fe-3965-4bbc-9846-3811431a37ee	middleName	user.attribute
b40f98fe-3965-4bbc-9846-3811431a37ee	true	id.token.claim
b40f98fe-3965-4bbc-9846-3811431a37ee	true	access.token.claim
b40f98fe-3965-4bbc-9846-3811431a37ee	middle_name	claim.name
b40f98fe-3965-4bbc-9846-3811431a37ee	String	jsonType.label
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	true	userinfo.token.claim
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	nickname	user.attribute
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	true	id.token.claim
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	true	access.token.claim
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	nickname	claim.name
c9a7a06b-6bb7-4a36-9e5f-39082898ef77	String	jsonType.label
c7ab5023-56c4-4602-a11f-6b17d5e089bb	true	userinfo.token.claim
c7ab5023-56c4-4602-a11f-6b17d5e089bb	username	user.attribute
c7ab5023-56c4-4602-a11f-6b17d5e089bb	true	id.token.claim
c7ab5023-56c4-4602-a11f-6b17d5e089bb	true	access.token.claim
c7ab5023-56c4-4602-a11f-6b17d5e089bb	preferred_username	claim.name
c7ab5023-56c4-4602-a11f-6b17d5e089bb	String	jsonType.label
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	true	userinfo.token.claim
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	profile	user.attribute
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	true	id.token.claim
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	true	access.token.claim
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	profile	claim.name
6e05972c-d89c-4cbe-a9fd-6cd26c9497a0	String	jsonType.label
1c181240-6626-40a5-9a77-8f11f45e49f6	true	userinfo.token.claim
1c181240-6626-40a5-9a77-8f11f45e49f6	picture	user.attribute
1c181240-6626-40a5-9a77-8f11f45e49f6	true	id.token.claim
1c181240-6626-40a5-9a77-8f11f45e49f6	true	access.token.claim
1c181240-6626-40a5-9a77-8f11f45e49f6	picture	claim.name
1c181240-6626-40a5-9a77-8f11f45e49f6	String	jsonType.label
58519ba1-9ca6-46a8-9c11-89c67621f5cf	true	userinfo.token.claim
58519ba1-9ca6-46a8-9c11-89c67621f5cf	website	user.attribute
58519ba1-9ca6-46a8-9c11-89c67621f5cf	true	id.token.claim
58519ba1-9ca6-46a8-9c11-89c67621f5cf	true	access.token.claim
58519ba1-9ca6-46a8-9c11-89c67621f5cf	website	claim.name
58519ba1-9ca6-46a8-9c11-89c67621f5cf	String	jsonType.label
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	true	userinfo.token.claim
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	gender	user.attribute
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	true	id.token.claim
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	true	access.token.claim
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	gender	claim.name
e6d4f650-4096-4ad3-94ff-caf4ced04eb1	String	jsonType.label
cf6179b9-74b5-4a8e-96b5-b6b55994a212	true	userinfo.token.claim
cf6179b9-74b5-4a8e-96b5-b6b55994a212	birthdate	user.attribute
cf6179b9-74b5-4a8e-96b5-b6b55994a212	true	id.token.claim
cf6179b9-74b5-4a8e-96b5-b6b55994a212	true	access.token.claim
cf6179b9-74b5-4a8e-96b5-b6b55994a212	birthdate	claim.name
cf6179b9-74b5-4a8e-96b5-b6b55994a212	String	jsonType.label
2c7bc770-1ed8-4818-b494-590b17832442	true	userinfo.token.claim
2c7bc770-1ed8-4818-b494-590b17832442	zoneinfo	user.attribute
2c7bc770-1ed8-4818-b494-590b17832442	true	id.token.claim
2c7bc770-1ed8-4818-b494-590b17832442	true	access.token.claim
2c7bc770-1ed8-4818-b494-590b17832442	zoneinfo	claim.name
2c7bc770-1ed8-4818-b494-590b17832442	String	jsonType.label
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	true	userinfo.token.claim
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	locale	user.attribute
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	true	id.token.claim
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	true	access.token.claim
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	locale	claim.name
83f0f1c9-f9f5-43ca-b398-7084ad6dcf2e	String	jsonType.label
19c862c8-bd13-44ad-b861-292b7207e5dd	true	userinfo.token.claim
19c862c8-bd13-44ad-b861-292b7207e5dd	updatedAt	user.attribute
19c862c8-bd13-44ad-b861-292b7207e5dd	true	id.token.claim
19c862c8-bd13-44ad-b861-292b7207e5dd	true	access.token.claim
19c862c8-bd13-44ad-b861-292b7207e5dd	updated_at	claim.name
19c862c8-bd13-44ad-b861-292b7207e5dd	String	jsonType.label
3780dc8b-6c36-4950-bd8e-553513effcbc	true	userinfo.token.claim
3780dc8b-6c36-4950-bd8e-553513effcbc	email	user.attribute
3780dc8b-6c36-4950-bd8e-553513effcbc	true	id.token.claim
3780dc8b-6c36-4950-bd8e-553513effcbc	true	access.token.claim
3780dc8b-6c36-4950-bd8e-553513effcbc	email	claim.name
3780dc8b-6c36-4950-bd8e-553513effcbc	String	jsonType.label
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	true	userinfo.token.claim
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	emailVerified	user.attribute
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	true	id.token.claim
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	true	access.token.claim
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	email_verified	claim.name
309b3e64-5f8f-471b-8abb-9aa4d59ba4f9	boolean	jsonType.label
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	formatted	user.attribute.formatted
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	country	user.attribute.country
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	postal_code	user.attribute.postal_code
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	true	userinfo.token.claim
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	street	user.attribute.street
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	true	id.token.claim
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	region	user.attribute.region
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	true	access.token.claim
8cf0ab96-a86e-4e57-81a1-a30b75007bcb	locality	user.attribute.locality
5b5e46e0-ae25-4850-82e2-dd93484d120d	true	userinfo.token.claim
5b5e46e0-ae25-4850-82e2-dd93484d120d	phoneNumber	user.attribute
5b5e46e0-ae25-4850-82e2-dd93484d120d	true	id.token.claim
5b5e46e0-ae25-4850-82e2-dd93484d120d	true	access.token.claim
5b5e46e0-ae25-4850-82e2-dd93484d120d	phone_number	claim.name
5b5e46e0-ae25-4850-82e2-dd93484d120d	String	jsonType.label
052fee33-c01f-4988-b1cd-156ddaccfbf6	true	userinfo.token.claim
052fee33-c01f-4988-b1cd-156ddaccfbf6	phoneNumberVerified	user.attribute
052fee33-c01f-4988-b1cd-156ddaccfbf6	true	id.token.claim
052fee33-c01f-4988-b1cd-156ddaccfbf6	true	access.token.claim
052fee33-c01f-4988-b1cd-156ddaccfbf6	phone_number_verified	claim.name
052fee33-c01f-4988-b1cd-156ddaccfbf6	boolean	jsonType.label
0084b45b-bf21-49fe-8a17-2f167ec28c09	true	multivalued
0084b45b-bf21-49fe-8a17-2f167ec28c09	foo	user.attribute
0084b45b-bf21-49fe-8a17-2f167ec28c09	true	access.token.claim
0084b45b-bf21-49fe-8a17-2f167ec28c09	realm_access.roles	claim.name
0084b45b-bf21-49fe-8a17-2f167ec28c09	String	jsonType.label
2a58768f-0dec-4473-bfed-44bcf66bc178	true	multivalued
2a58768f-0dec-4473-bfed-44bcf66bc178	foo	user.attribute
2a58768f-0dec-4473-bfed-44bcf66bc178	true	access.token.claim
2a58768f-0dec-4473-bfed-44bcf66bc178	resource_access.${client_id}.roles	claim.name
2a58768f-0dec-4473-bfed-44bcf66bc178	String	jsonType.label
01553be7-139c-4239-982b-710d2ebc4844	true	userinfo.token.claim
01553be7-139c-4239-982b-710d2ebc4844	username	user.attribute
01553be7-139c-4239-982b-710d2ebc4844	true	id.token.claim
01553be7-139c-4239-982b-710d2ebc4844	true	access.token.claim
01553be7-139c-4239-982b-710d2ebc4844	upn	claim.name
01553be7-139c-4239-982b-710d2ebc4844	String	jsonType.label
bca85f32-1686-4a0c-863c-4b5ed3d17483	true	multivalued
bca85f32-1686-4a0c-863c-4b5ed3d17483	foo	user.attribute
bca85f32-1686-4a0c-863c-4b5ed3d17483	true	id.token.claim
bca85f32-1686-4a0c-863c-4b5ed3d17483	true	access.token.claim
bca85f32-1686-4a0c-863c-4b5ed3d17483	groups	claim.name
bca85f32-1686-4a0c-863c-4b5ed3d17483	String	jsonType.label
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	true	userinfo.token.claim
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	locale	user.attribute
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	true	id.token.claim
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	true	access.token.claim
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	locale	claim.name
6db60a15-d75e-4d07-9c7f-8642cf2a5b89	String	jsonType.label
6125cfd1-f524-4478-9e92-c96f75eb31e8	clientId	user.session.note
6125cfd1-f524-4478-9e92-c96f75eb31e8	true	id.token.claim
6125cfd1-f524-4478-9e92-c96f75eb31e8	true	access.token.claim
6125cfd1-f524-4478-9e92-c96f75eb31e8	clientId	claim.name
6125cfd1-f524-4478-9e92-c96f75eb31e8	String	jsonType.label
5df89693-273b-4466-ab5b-a543942c9b08	clientHost	user.session.note
5df89693-273b-4466-ab5b-a543942c9b08	true	id.token.claim
5df89693-273b-4466-ab5b-a543942c9b08	true	access.token.claim
5df89693-273b-4466-ab5b-a543942c9b08	clientHost	claim.name
5df89693-273b-4466-ab5b-a543942c9b08	String	jsonType.label
a7537049-c4a8-41fa-95ab-e42ffaa4d93e	clientAddress	user.session.note
a7537049-c4a8-41fa-95ab-e42ffaa4d93e	true	id.token.claim
a7537049-c4a8-41fa-95ab-e42ffaa4d93e	true	access.token.claim
a7537049-c4a8-41fa-95ab-e42ffaa4d93e	clientAddress	claim.name
a7537049-c4a8-41fa-95ab-e42ffaa4d93e	String	jsonType.label
6c880427-ccaa-4708-8fb1-8438e568a762	true	multivalued
6c880427-ccaa-4708-8fb1-8438e568a762	false	userinfo.token.claim
6c880427-ccaa-4708-8fb1-8438e568a762	false	id.token.claim
6c880427-ccaa-4708-8fb1-8438e568a762	true	access.token.claim
6c880427-ccaa-4708-8fb1-8438e568a762	roles	claim.name
6c880427-ccaa-4708-8fb1-8438e568a762	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
MedLabMS	60	300	300	public.v2	keycloak	medlabms	t	f	0	medlabms	MedLabMS	1650406110	\N	f	t	t	f	EXTERNAL	1800	36000	f	t	71250ec0-20be-40e0-b7c1-d07906469908	1800	f	\N	f	f	f	t	0	1	30	6	HmacSHA1	totp	2237847d-6238-4ddb-aad4-d17914cdbf54	daddec87-b2be-4de0-a5cd-8a8ae26a195c	2f45d891-25d4-44cf-8787-582d54a64c9c	88ab87c9-0eb2-4753-a6d3-3af24b53fb8d	a34c1873-c0fd-438c-adb1-70193a7ac08a	2592000	f	900	t	f	bd97d87d-6293-42f9-8654-add42ec83c87	0	f	0	0	c323ce56-7ba1-4e9c-b89a-d8a426090013
master	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	b912181c-b693-4335-a0bd-e4a7e4e5811d	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	e831f332-635d-42fb-a7ee-6b14c6763a73	125c4be6-5a99-4994-b8ab-5bfc741306b1	b0ddfd06-db22-4454-9f73-4f7eee64188f	4ad9d0bf-5539-406c-9e20-432aa4369b49	dc44410b-87e3-4c00-9f4a-649200dcf570	2592000	f	900	t	f	be78d0d6-9571-4cf6-b9f9-9c4410acfb41	0	f	0	0	3ad939e6-0588-461d-98ea-df431f8c41ef
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	master	
_browser_header.xContentTypeOptions	master	nosniff
_browser_header.xRobotsTag	master	none
_browser_header.xFrameOptions	master	SAMEORIGIN
_browser_header.contentSecurityPolicy	master	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	master	1; mode=block
_browser_header.strictTransportSecurity	master	max-age=31536000; includeSubDomains
bruteForceProtected	master	false
permanentLockout	master	false
maxFailureWaitSeconds	master	900
minimumQuickLoginWaitSeconds	master	60
waitIncrementSeconds	master	60
quickLoginCheckMilliSeconds	master	1000
maxDeltaTimeSeconds	master	43200
failureFactor	master	30
displayName	master	Keycloak
displayNameHtml	master	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	master	RS256
offlineSessionMaxLifespanEnabled	master	false
offlineSessionMaxLifespan	master	5184000
displayName	MedLabMS	MedLab MS
bruteForceProtected	MedLabMS	false
permanentLockout	MedLabMS	false
maxFailureWaitSeconds	MedLabMS	900
minimumQuickLoginWaitSeconds	MedLabMS	60
waitIncrementSeconds	MedLabMS	60
quickLoginCheckMilliSeconds	MedLabMS	1000
maxDeltaTimeSeconds	MedLabMS	43200
failureFactor	MedLabMS	30
actionTokenGeneratedByAdminLifespan	MedLabMS	43200
actionTokenGeneratedByUserLifespan	MedLabMS	300
defaultSignatureAlgorithm	MedLabMS	RS256
offlineSessionMaxLifespanEnabled	MedLabMS	false
offlineSessionMaxLifespan	MedLabMS	5184000
webAuthnPolicyRpEntityName	MedLabMS	keycloak
webAuthnPolicySignatureAlgorithms	MedLabMS	ES256
webAuthnPolicyRpId	MedLabMS	
webAuthnPolicyAttestationConveyancePreference	MedLabMS	not specified
webAuthnPolicyAuthenticatorAttachment	MedLabMS	not specified
webAuthnPolicyRequireResidentKey	MedLabMS	not specified
oauth2DeviceCodeLifespan	MedLabMS	600
oauth2DevicePollingInterval	MedLabMS	5
webAuthnPolicyUserVerificationRequirement	MedLabMS	not specified
webAuthnPolicyCreateTimeout	MedLabMS	0
webAuthnPolicyAvoidSameAuthenticatorRegister	MedLabMS	false
webAuthnPolicyRpEntityNamePasswordless	MedLabMS	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	MedLabMS	ES256
webAuthnPolicyRpIdPasswordless	MedLabMS	
webAuthnPolicyAttestationConveyancePreferencePasswordless	MedLabMS	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	MedLabMS	not specified
webAuthnPolicyRequireResidentKeyPasswordless	MedLabMS	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	MedLabMS	not specified
webAuthnPolicyCreateTimeoutPasswordless	MedLabMS	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	MedLabMS	false
client-policies.profiles	MedLabMS	{"profiles":[]}
client-policies.policies	MedLabMS	{"policies":[]}
_browser_header.contentSecurityPolicyReportOnly	MedLabMS	
_browser_header.xContentTypeOptions	MedLabMS	nosniff
_browser_header.xRobotsTag	MedLabMS	none
_browser_header.xFrameOptions	MedLabMS	SAMEORIGIN
cibaBackchannelTokenDeliveryMode	MedLabMS	poll
cibaExpiresIn	MedLabMS	120
cibaInterval	MedLabMS	5
cibaAuthRequestedUserHint	MedLabMS	login_hint
parRequestUriLifespan	MedLabMS	60
userProfileEnabled	MedLabMS	false
_browser_header.contentSecurityPolicy	MedLabMS	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	MedLabMS	1; mode=block
_browser_header.strictTransportSecurity	MedLabMS	max-age=31536000; includeSubDomains
clientSessionIdleTimeout	MedLabMS	0
clientSessionMaxLifespan	MedLabMS	0
clientOfflineSessionIdleTimeout	MedLabMS	0
clientOfflineSessionMaxLifespan	MedLabMS	0
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
master	jboss-logging
MedLabMS	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	master
password	password	t	t	MedLabMS
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
MedLabMS	MedlabMS	replyToDisplayName
MedLabMS		starttls
MedLabMS		auth
MedLabMS	1025	port
MedLabMS	localhost	host
MedLabMS	medlabms@gmail.com	replyTo
MedLabMS	medlabms@gmail.com	from
MedLabMS	MedLabMS	fromDisplayName
MedLabMS		ssl
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
MedLabMS	
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
9ea6db48-ca0d-41a2-ba9a-9c339846f3fb	/realms/master/account/*
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	/realms/master/account/*
5279cdb1-a17d-4ab8-a091-8e909ee0d898	/admin/master/console/*
709f81e4-9774-4ad5-9aa9-723903b1c90a	/realms/MedLabMS/account/*
9faaf662-da17-4f1c-91c8-e6cfb0794eef	/realms/MedLabMS/account/*
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	/admin/MedLabMS/console/*
50aab8c6-991d-4294-9b59-d9d59426ce08	http://localhost:8080/*
50aab8c6-991d-4294-9b59-d9d59426ce08	http://localhost:8764/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
5a1643cb-c1c1-40f5-be62-63f383936757	VERIFY_EMAIL	Verify Email	master	t	f	VERIFY_EMAIL	50
2997e20e-118b-4e6c-ba94-fcfa83dedbb3	UPDATE_PROFILE	Update Profile	master	t	f	UPDATE_PROFILE	40
86f9266e-49ab-476c-bc62-b6994f51fc9b	CONFIGURE_TOTP	Configure OTP	master	t	f	CONFIGURE_TOTP	10
d5567299-e32f-48c9-88fa-7cd267601ff0	UPDATE_PASSWORD	Update Password	master	t	f	UPDATE_PASSWORD	30
e9ca504c-a9b1-47a2-a0f2-526e8af5ba01	terms_and_conditions	Terms and Conditions	master	f	f	terms_and_conditions	20
9bce92ec-da83-493a-a081-efa7455b8de5	update_user_locale	Update User Locale	master	t	f	update_user_locale	1000
af341831-c2a8-4171-a0d8-15a0cad359f4	delete_account	Delete Account	master	f	f	delete_account	60
792dfbd9-4121-47e9-bb91-71c3a570e6ab	VERIFY_EMAIL	Verify Email	MedLabMS	t	f	VERIFY_EMAIL	50
c00e324c-92b9-4793-ac33-c80cc07f3145	UPDATE_PROFILE	Update Profile	MedLabMS	t	f	UPDATE_PROFILE	40
e56eee57-b39e-428f-9a5c-7145a7569d83	CONFIGURE_TOTP	Configure OTP	MedLabMS	t	f	CONFIGURE_TOTP	10
83044f1a-46ce-48ff-a2c6-c8d38ff20d01	UPDATE_PASSWORD	Update Password	MedLabMS	t	f	UPDATE_PASSWORD	30
1fb8835e-5a25-428b-ae83-bfd561160ca0	terms_and_conditions	Terms and Conditions	MedLabMS	f	f	terms_and_conditions	20
589e11cf-30e4-4057-94b2-fd3865c82f5e	update_user_locale	Update User Locale	MedLabMS	t	f	update_user_locale	1000
65b4073e-b8fc-4729-9d8b-f259b591ef90	delete_account	Delete Account	MedLabMS	f	f	delete_account	60
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
dcd5f1f7-6888-47b3-9dbd-084b119d4fbe	b3358d70-47bc-41c1-a3e2-a6eea1b36a03
9faaf662-da17-4f1c-91c8-e6cfb0794eef	3c5e8ad8-7e3f-4324-8653-a68dd2194870
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
locale	en	85785f10-2481-41c1-9508-495d61e3211a	22736e2e-33d9-4ca8-8700-9129d5a17897
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
d0ae2adf-85d9-4246-b2ec-1eec9557ed8b	\N	c7e3d990-c7c3-44a8-89e2-25abe237080a	f	t	\N	\N	\N	MedLabMS	service-account-super-client	1635891220354	3ec008e8-b299-41da-a7e7-863e71dbc181	0
85785f10-2481-41c1-9508-495d61e3211a	admin@admin.com	admin@admin.com	f	t	\N	admin	admin	master	admin	1635890843017	\N	0
8a0863e6-c1f5-4823-9ecb-3ae9055cd6ef	zukaargjenda@gmail.com	zukaargjenda@gmail.com	f	t	\N	Argjenda	Zuka	MedLabMS	argjendazuka	1650482894426	\N	0
67d50d0a-b520-481f-a65b-0605021bfda9	rrapbraina@gmail.com	rrapbraina@gmail.com	t	t	\N	Rrap	Braina	MedLabMS	rrapbraina	1650483325735	\N	0
406cdfd4-24a1-493b-95e9-7cd4fcb8ae61	shpatbraina@gmail.com	shpatbraina@gmail.com	t	t	\N	Shpat	Braina	MedLabMS	shpatbraina	1650482876147	\N	0
a1bd915e-e4e0-4c1e-b256-f4ba429567f5	test1@test.com	test1@test.com	t	t	\N	test	test	MedLabMS	test1	1635893258929	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
d15ed60f-6d5d-4aef-b227-e31ccdee0a1b	a1bd915e-e4e0-4c1e-b256-f4ba429567f5
4ff76338-473a-4b7c-869c-94088ac8ed20	406cdfd4-24a1-493b-95e9-7cd4fcb8ae61
f9d06b08-8b93-4057-a3ba-ebc3794cf98e	8a0863e6-c1f5-4823-9ecb-3ae9055cd6ef
4ff76338-473a-4b7c-869c-94088ac8ed20	67d50d0a-b520-481f-a65b-0605021bfda9
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
3ad939e6-0588-461d-98ea-df431f8c41ef	85785f10-2481-41c1-9508-495d61e3211a
76153201-c763-493b-9e50-881fc285c1cc	85785f10-2481-41c1-9508-495d61e3211a
5ed4cc92-7f87-4bb9-aa66-19f08a432ad3	d0ae2adf-85d9-4246-b2ec-1eec9557ed8b
ac66b3ca-b167-467d-83d2-ec90d0ee4b4c	d0ae2adf-85d9-4246-b2ec-1eec9557ed8b
5372828d-1cdc-411f-b959-437e1cb0e824	d0ae2adf-85d9-4246-b2ec-1eec9557ed8b
a24c6f36-7c52-4d68-bde2-78aa88e5d418	d0ae2adf-85d9-4246-b2ec-1eec9557ed8b
144372cb-18dd-42ad-9f85-be3071e560e3	d0ae2adf-85d9-4246-b2ec-1eec9557ed8b
c323ce56-7ba1-4e9c-b89a-d8a426090013	a1bd915e-e4e0-4c1e-b256-f4ba429567f5
c323ce56-7ba1-4e9c-b89a-d8a426090013	d0ae2adf-85d9-4246-b2ec-1eec9557ed8b
c323ce56-7ba1-4e9c-b89a-d8a426090013	406cdfd4-24a1-493b-95e9-7cd4fcb8ae61
c323ce56-7ba1-4e9c-b89a-d8a426090013	8a0863e6-c1f5-4823-9ecb-3ae9055cd6ef
c323ce56-7ba1-4e9c-b89a-d8a426090013	67d50d0a-b520-481f-a65b-0605021bfda9
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
5279cdb1-a17d-4ab8-a091-8e909ee0d898	+
a8915d48-59f9-4f83-bdd3-8d2f4aef6b80	+
50aab8c6-991d-4294-9b59-d9d59426ce08	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

