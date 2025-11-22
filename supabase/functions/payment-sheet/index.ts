// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') as string, {
  apiVersion: '2022-11-15',
  httpClient: Stripe.createFetchHttpClient(),
})

serve(async (req) => {
  try {
    // 1. Obtener datos del request
    const { amount, currency } = await req.json()

    // 2. Crear o buscar un cliente en Stripe (Simplificado: crea uno nuevo siempre)
    // En producción, deberías guardar el stripe_customer_id en tu tabla de usuarios de Supabase
    const customer = await stripe.customers.create()

    // 3. Crear una Ephemeral Key (necesaria para el Payment Sheet)
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: '2022-11-15' }
    )

    // 4. Crear el PaymentIntent (La intención de cobro)
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // En centavos (ej: 2499 para $24.99)
      currency: currency,
      customer: customer.id,
      automatic_payment_methods: {
        enabled: true,
      },
    })

    // 5. Retornar las 3 claves necesarias a la App Flutter
    return new Response(
      JSON.stringify({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
      }),
      {
        headers: { "Content-Type": "application/json" },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 400,
    })
  }
})
