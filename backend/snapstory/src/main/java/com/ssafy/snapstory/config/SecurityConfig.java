package com.ssafy.snapstory.config;

import com.google.firebase.auth.FirebaseAuth;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    private final UserDetailsService userDetailsService;

    private final FirebaseAuth firebaseAuth;

    private final UserRepository userRepository;

        @Override
    public void configure(HttpSecurity http) throws Exception {
            http.csrf().disable().cors();
            http.authorizeRequests().antMatchers("/swagger-resources/**").permitAll();
            http.authorizeRequests()
                .anyRequest().authenticated().and()
                .addFilterBefore(new FirebaseTokenFilter(userDetailsService, firebaseAuth,userRepository),
                        UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling()
                .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED));
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        // 회원가입, 메인페이지, 리소스
        web.ignoring().antMatchers(HttpMethod.POST, "/api/v1/users")
                .antMatchers("/swagger-ui/**")
                .antMatchers("/resources/**")
                .antMatchers("/swagger-resources/**")
                .antMatchers("/v3/api-docs",  "/configuration/ui",
                "/swagger-resources", "/configuration/security",
                "/swagger-ui.html", "/webjars/**","/swagger/**");
    }


}