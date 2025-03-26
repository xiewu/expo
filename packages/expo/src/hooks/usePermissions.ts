import { useCallback, useMemo } from 'react';

export type Permission = {
  check: () => boolean;
  request: () => boolean;
};

export function usePermissions(permissions: Permission[] | Permission) {
  const permissionsArray = Array.isArray(permissions) ? permissions : [permissions];
  const check = useCallback(
    () => permissionsArray.reduce((result, current) => current.check() && result, true),
    [permissionsArray]
  );
  const request = useCallback(async () => {
    const results = await Promise.all(permissionsArray.map((p) => p.request()));
    return results.reduce((result, current) => current && result, true);
  }, [permissionsArray]);

  // update on request or from events from native – TBD
  const granted = useMemo(check, [permissions]);

  return { granted, request, check };
}
