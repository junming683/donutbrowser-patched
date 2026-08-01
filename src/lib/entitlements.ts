import type { CloudUser, Entitlements } from "@/types";

/**
 * The user's effective entitlements. Always returns full capabilities.
 */
export function getEntitlements(
  _user: CloudUser | null | undefined,
): Entitlements {
  return {
    active: true,
    browserAutomation: true,
    crossOsFingerprints: true,
    cloudBackup: true,
    teamCollaboration: true,
    profileLimit: 99999,
    requestsPerHour: 100000,
  };
}