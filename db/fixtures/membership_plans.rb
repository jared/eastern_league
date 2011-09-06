MembershipPlan.seed(:id,
  {id: 1, name: '1 Year Individual', amount: 15.00, renewal_period: 12},
  {id: 2, name: '1 Year Family', amount: 8.00, renewal_period: 12, primary: false},
  {id: 3, name: '2 Year Individual', amount: 25.00, renewal_period: 24},
  {id: 4, name: '2 Year Family', amount: 12.00, renewal_period: 24, primary: false},
  {id: 5, name: 'Lifetime', amount: 0.00, renewal_period: 999, visible: false}
)
