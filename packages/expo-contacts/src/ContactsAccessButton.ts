import { requireNativeViewManager } from 'expo-modules-core';
import { ViewProps } from 'react-native';

interface ContactsAccessButtonProps extends ViewProps {
  queryString: string;
  padding?: number;
}

export const ContactsAccessButton =
  requireNativeViewManager<ContactsAccessButtonProps>('ExpoContacts');
