import React from 'react';
import { Text } from 'react-native';

import { router } from '../exports';
import { store } from '../global-state/router-store';
import { Tabs } from '../layouts/Tabs';
import { act, renderRouter, screen } from '../testing-library';

it('should not render generated screens', () => {
  renderRouter({
    _layout: () => <Tabs />,
    index: () => <Text testID="index">Index</Text>,
  });

  expect(screen.getByTestId('index')).toBeVisible();

  const tabList = screen.getByLabelText('index, tab, 1 of 3').parent;

  expect(tabList?.children).toHaveLength(1);
});

it('screens can be hidden', () => {
  renderRouter({
    _layout: () => (
      <Tabs>
        <Tabs.Screen name="hidden" />
      </Tabs>
    ),
    index: () => <Text testID="index">Index</Text>,
    hidden: () => <Text testID="index">Index</Text>,
  });

  expect(screen.getByTestId('index')).toBeVisible();

  const tabList = screen.getByLabelText('index, tab, 2 of 4').parent;

  expect(tabList?.children).toHaveLength(1);
});

it('can push screens', () => {
  renderRouter(
    {
      _layout: () => <Tabs />,
      one: () => <Text testID="one">One</Text>,
      two: () => <Text testID="two">Two</Text>,
    },
    {
      initialUrl: '/one',
    }
  );

  expect(screen.getByTestId('one')).toBeVisible();

  act(() => router.push('/two'));

  expect(screen.getByTestId('two')).toBeVisible();
});

it('works with goBack', () => {
  renderRouter(
    {
      _layout: () => <Tabs />,
      one: () => <Text testID="one">One</Text>,
      two: () => <Text testID="two">Two</Text>,
      three: () => <Text testID="three">Three</Text>,
    },
    {
      initialUrl: '/one',
    }
  );

  expect(screen.getByTestId('one')).toBeVisible();

  act(() => router.push('/two'));
  act(() => router.push('/three'));

  expect(screen.getByTestId('three')).toBeVisible();

  act(() => router.back());

  // The default back behavior of tabs is first screen
  expect(screen.getByTestId('one')).toBeVisible();
});

it('works with goBack (history)', () => {
  renderRouter(
    {
      _layout: () => <Tabs backBehavior="history" />,
      one: () => <Text testID="one">One</Text>,
      two: () => <Text testID="two">Two</Text>,
      three: () => <Text testID="three">Three</Text>,
    },
    {
      initialUrl: '/one',
    }
  );

  expect(screen.getByTestId('one')).toBeVisible();

  act(() => router.push('/two'));
  act(() => router.push('/three'));

  expect(screen.getByTestId('three')).toBeVisible();

  act(() => router.back());

  expect(screen.getByTestId('two')).toBeVisible();
});

it('can use replace navigation', () => {
  renderRouter(
    {
      _layout: () => <Tabs />,
      one: () => <Text testID="one">One</Text>,
      two: () => <Text testID="two">Two</Text>,
    },
    {
      initialUrl: '/one',
    }
  );

  // The Tabs
  expect(screen.getByLabelText('one, tab, 1 of 4')).toBeVisible();
  expect(screen.getByLabelText('two, tab, 2 of 4')).toBeVisible();

  expect(screen.getByTestId('one')).toBeVisible();

  act(() => router.replace('/two'));
  expect(screen.getByTestId('two')).toBeVisible();
  expect(screen.getByLabelText('two, tab, 2 of 4')).toBeVisible();
  expect(store.state).toStrictEqual({
    index: 0,
    key: expect.any(String),
    preloadedRoutes: [],
    routeNames: ['__root'],
    routes: [
      {
        key: expect.any(String),
        name: '__root',
        params: undefined,
        state: {
          history: [
            {
              key: expect.any(String),
              type: 'route',
            },
          ],
          index: 1,
          key: expect.any(String),
          preloadedRouteKeys: [],
          routeNames: ['one', 'two', '_sitemap', '+not-found'],
          routes: [
            {
              key: expect.any(String),
              name: 'one',
              params: undefined,
              path: '/one',
            },
            {
              key: expect.any(String),
              name: 'two',
              params: {},
              path: undefined,
            },
            {
              key: expect.any(String),
              name: '_sitemap',
              params: undefined,
            },
            {
              key: expect.any(String),
              name: '+not-found',
              params: undefined,
            },
          ],
          stale: false,
          type: 'tab',
        },
      },
    ],
    stale: false,
    type: 'stack',
  });
});

it('can use replace navigation with history backBehavior', () => {
  renderRouter(
    {
      _layout: () => <Tabs backBehavior="history" />,
      one: () => <Text testID="one">One</Text>,
      two: () => <Text testID="two">Two</Text>,
      three: () => <Text testID="three">Three</Text>,
    },
    {
      initialUrl: '/one',
    }
  );

  expect(screen.getByTestId('one')).toBeVisible();

  act(() => router.push('/two'));
  act(() => router.replace('/three'));

  expect(screen.getByTestId('three')).toBeVisible();

  act(() => router.back());

  expect(screen.getByTestId('one')).toBeVisible();
});
