#include <bits/stdc++.h>
using namespace std;

// Definition Section
//--------------------------------------------------------------
typedef long long ll;
#define nl cout << endl
#define pb push_back
#define fast                         \
    {                                \
        ios::sync_with_stdio(false); \
        cin.tie(NULL);               \
    }
//--------------------------------------------------------------

int main()
{
    fast

        ll a,
        b, c, x, y, z, n, m, tc, cnt = 0, ans = 0, sum = 0;
    string s, s1, s2, s3;

    cin >> tc;
    while (tc--)
    {
        cin >> n;
        vector<ll> a(n + 1);
        for (ll k = 1; k <= n; k++)
            cin >> a[k];

        for (ll k = 1; k <= n; k++)
        {
            cout << (n - a[k] + 1) << " ";
        }
        nl;
    }
    return 0;
}